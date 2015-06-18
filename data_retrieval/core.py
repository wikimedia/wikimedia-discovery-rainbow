import re
import gzip
import datetime
import os.path
import csv
from collections import Counter

#Regexes for parsing
is_valid_regex = re.compile("^\d{4}-\d{2}-\d{2}")
has_zero_results_regex = re.compile("Found 0 total results")
query_regex = re.compile("(?<= search for ').*(?=' against .*wiki_content took)")

#File paths for output
output_daily = "/a/aggregate-datasets/search/daily_pages/"
output_single = "/a/aggregate-datasets/search/cirrus_query_aggregates.tsv"

#Construct a filepath
def construct_filepath(date = None):
  if date is None:
    date = datetime.date.fromordinal(datetime.date.today().toordinal()-1)
  parsed_date = date.strftime("%Y%m%d")
  path = "/a/mw-log/archive/CirrusSearchRequests.log-" + parsed_date + ".gz"
  return path, date

#Check if a line is even valid
def is_valid(row):
  if(re.search(is_valid_regex, row)):
    return True
  return False

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
    write_obj.writerow([str(date), "Zero Result Queries", str(query_count)])
    
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
  zero_result_count = 0;
  zero_result_queries = list();
  queries = 0;
  connection = gzip.open(filename)
  for line in connection:
    if(is_valid(line)):
      queries +=1
      if(is_zero(line)):
        zero_result_count += 1
        zero_result_queries.append(extract_query(line))
  connection.close()
  zero_result_queries = Counter(zero_result_queries)
  return(queries, zero_result_count, zero_result_queries.most_common(100))
  
filepath, date = construct_filepath()
query_count, zero_count, zero_results = parse_file(filepath)
single_write(date, query_count, zero_count)

