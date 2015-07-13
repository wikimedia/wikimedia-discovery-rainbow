import re
import gzip
import datetime
import os.path
import csv
from collections import Counter, OrderedDict
from sys import exit

#Regexes for parsing
is_valid_regex = re.compile("^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}")
has_zero_results_regex = re.compile("Found 0 total results")
query_regex = re.compile("(?<= search for ').*(?=' against .*wiki_content took)")
execution_id_regex = re.compile("by executor (.{16})\.$")

#File paths for output
output_daily = "/a/aggregate-datasets/search/daily_pages/"
output_single = "/a/aggregate-datasets/search/cirrus_query_aggregates.tsv"

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

#Construct a filepath
def construct_filepath(date = None):
  if date is None:
    date = datetime.date.fromordinal(datetime.date.today().toordinal()-1)
  parsed_date = date.strftime("%Y%m%d")
  path = "/a/mw-log/archive/CirrusSearchRequests.log-" + parsed_date + ".gz"
  return path, date

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

#Check if a request returned zero results
def is_zero(row):
  if(re.search(has_zero_results_regex, row)):
    return True
  return False

#Extract the actual query string from a row
def extract_query(row):
  match_result = re.search(query_regex, row)
  if(match_result is None):
    return ""
  return match_result.group(0)

#Write out to a file
def single_write(date, query_count, zero_count):
  if(os.path.exists(output_single) == False):
    with open(output_single, "wb") as tsv_file:
      write_obj = csv.writer(tsv_file, delimiter = "\t")
      write_obj.writerow(["date","variable","value"])
  with open(output_single, "ab") as tsv_file:
    write_obj = csv.writer(tsv_file, delimiter = "\t")
    write_obj.writerow([str(date), "Search Queries", str(query_count)])
    write_obj.writerow([str(date), "Zero Result Queries", str(zero_count)])

def daily_write(date, zero_results):
  with open((output_daily + date.strftime("%Y%m%d") + ".tsv"), "ab") as tsv_file:
    write_obj = csv.writer(tsv_file, delimiter = "\t")
    for line in zero_results:
      line = re.sub("(\\t|\\n|\")", "", line)
      write_obj.writerow([line])

#For each line in the file, if it's valid, increment the query count.
#If it has zero results, log the query to the query list and increment
#the zero count.
def parse_file(filename):
  stats = {
    'queries': 0,
    'zero_result_count': 0,
    'zero_result_queries': list(),
  }
  def count_query(lines):
    # Just assume whichever logline showed up last is the one we want
    line = lines[-1]
    stats['queries'] += 1
    if is_zero(line):
      stats['zero_result_count'] += 1
      stats['zero_result_queries'].append(extract_query(line))

  collector = BoundedRelatedStatCollector(count_query)
  connection = gzip.open(filename)
  for line in connection:
    timestamp = extract_timestamp(line)
    if timestamp != None:
      execution_id = extract_execution_id(line)
      collector.push(execution_id, line, timestamp)
  connection.close()
  collector.flush()

  zero_result_queries = Counter(stats['zero_result_queries'])
  return(stats['queries'], stats['zero_result_count'], zero_result_queries.most_common(100))

filepath, date = construct_filepath()
query_count, zero_count, zero_results = parse_file(filepath)
single_write(date, query_count, zero_count)
#daily_write(date, zero_results)
exit()
