import re
from collections import Counter

#Regexes for parsing
is_valid_regex = re.compile("^\d{4}-\d{2}-\d{2}")
has_zero_results_regex = re.compile("Found 0 total results")
query_regex = re.compile("(?<= search for ').*(?=' against .*wiki_content took)")

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

#For each line in the file, if it's valid, increment the query count.
#If it has zero results, log the query to the query list and increment
#the zero count.
def parse_file(filename):
  zero_result_count = 0;
  zero_result_queries = list();
  queries = 0;
  connection = open(filename, "r");
  for line in connection:
    if(is_valid(line)):
      queries +=1
      if(is_zero(line)):
        zero_result_count += 1
        zero_result_queries.append(extract_query(line))
  connection.close()
  zero_result_queries = Counter(zero_result_queries)
  return(queries, zero_result_count, zero_result_queries.most_common(100))

query_count, zero_count, zero_results = parse_file(filename)
