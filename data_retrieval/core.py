import re
import gzip
import datetime
import os.path
import csv
from collections import Counter, OrderedDict
from sys import exit
from floccus import check
from floccus import misc
from floccus import get

#Regexes for parsing
is_valid_regex = re.compile("^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}")
has_zero_results_regex = re.compile("Found 0 total results")
execution_id_regex = re.compile("by executor (\d{9,})$")

#File paths for output
output_daily = "/home/ironholds/zero_results/"
aggregate_filepath = "/a/aggregate-datasets/search/cirrus_query_aggregates.tsv"
breakdown_filepath = "/a/aggregate-datasets/search/cirrus_query_breakdowns.tsv"
suggest_filepath = "/a/aggregate-datasets/search/cirrus_suggestion_breakdown.tsv"

class BoundedRelatedStatCollector(object):
  '''
  Collects related log lines that occur within a provided timedelta of
  another log line with the same group_by value.
  '''
  def __init__(self, callback, bounds=None):
    self.data = OrderedDict()
    self.callback = callback
    self.bounds = bounds if bounds else datetime.timedelta(seconds=120)
    self.visited = 0

  def push(self, group_by, line, timestamp):
    if group_by == None:
      self.callback([line])
      return

    if group_by in self.data:
      values, maxTimestamp = self.data[group_by]
      # delete the key so it moves to the end of the list
      del self.data[group_by]
      values.append(line)
      if timestamp > maxTimestamp:
        maxTimestamp = timestamp
    else:
      values = [line]
      maxTimestamp = timestamp

    self.data[group_by] = (values, maxTimestamp)

    self.visited += 1
    if self.visited % 1000 == 0:
      flush_up_to = maxTimestamp - self.bounds;
      self.flush(flush_up_to)

  def flush(self, max_timestamp=None):
    for group_by in self.data:
      values, timestamp = self.data[group_by]
      if max_timestamp != None and timestamp > max_timestamp:
        return
      self.callback(values)
      del self.data[group_by]

#Check if a line is even valid
def extract_timestamp(row):
  match = is_valid_regex.match(row)
  if match:
    try:
      return datetime.datetime.strptime(match.group(), '%Y-%m-%d %I:%M:%S')
    except ValueError:
      return None
  else:
    return None

def extract_execution_id(row):
  match = execution_id_regex.search(row)
  if match:
    return match.group(1)
  else:
    return None

def daily_write(date, zero_results):
  with open((output_daily + date + ".tsv"), "ab") as tsv_file:
    write_obj = csv.writer(tsv_file, delimiter = "\t")
    for line in zero_results:
      start = re.sub("(\\t|\\n|\")", "", line[0])
      write_obj.writerow([start, str(line[1])])

#For each line in the file, if it's valid, increment the query count.
#If it has zero results, log the query to the query list and increment
#the zero count.
def parse_file(filename):
  stats = {
    'queries': 0,
    'zero_result_count': 0,
    'prefix_queries': 0,
    'prefix_zero': 0,
    'full_queries': 0,
    'full_zero': 0,
    'suggested_queries': 0,
    'suggested_zero': 0,
    'zero_result_queries': list(),
  }
  def count_query(lines):
    # Just assume whichever logline showed up last is the one we want
    line = lines[-1]
    if check.check_prefix_search(line):
      stats['queries'] += 1
      stats['prefix_queries'] += 1
      if check.check_zero(line):
        stats['prefix_zero'] += 1
        stats['zero_result_queries'].append(get.get_query(line))
    elif check.check_full_search(line):
      stats['queries'] += 1
      stats['full_queries'] += 1
      if check.check_zero(line):
        stats['full_zero'] += 1
        stats['zero_result_queries'].append(get.get_query(line))
      if check.check_suggestion(line):
        stats['suggested_queries'] += 1
        if check.check_zero(line):
          stats['suggested_zero'] += 1

  collector = BoundedRelatedStatCollector(count_query)
  connection = gzip.open(filename)
  for line in connection:
    timestamp = extract_timestamp(line)
    if timestamp is not None:
      execution_id = extract_execution_id(line)
      collector.push(execution_id, line, timestamp)

  connection.close()
  collector.flush()

  zero_result_queries = Counter(stats['zero_result_queries']).most_common(100)
  high_level_stats = Counter({"Search Queries": stats['queries'],
    "Zero Result Queries": stats['prefix_zero'] + stats['full_zero']
  })
  breakdown_stats = Counter({
    "Full-Text Search": float(stats['full_zero'])/stats['full_queries'],
    "Prefix Search": float(stats['prefix_zero'])/stats['prefix_queries']
  })

  suggestion_stats = Counter({
    "Searches with Suggestions": float(stats['suggested_zero'])/stats['suggested_queries']
  })
  return(high_level_stats, breakdown_stats, suggestion_stats, zero_result_queries)

#Run and write out
filepath, date = misc.get_filepath()
high_level, breakdown, suggests, zero_results = parse_file(filepath)
misc.write_counter(high_level, date, aggregate_filepath)
misc.write_counter(breakdown, date, breakdown_filepath)
misc.write_counter(suggests, date, suggest_filepath)
daily_write(date, zero_results)
exit()
