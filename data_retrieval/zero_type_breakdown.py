from floccus import misc
from floccus import check
import gzip
from collections import Counter

def main(date = None):
  filepath, date = misc.get_filepath(date)
  output_count = Counter({'prefix_zero': 0, 'prefix_nonzero': 0, 'full_zero': 0, 'full_nonzero': 0})
  file = gzip.open(filepath)
  for line in file:
    if check.check_valid(line):
      if check.check_prefix_search(line):
        if check.check_zero(line):
          output_count['prefix_zero'] += 1
        else:
          output_count['prefix_nonzero'] += 1
      elif check.check_full_search(line):
        if check.check_zero(line):
          output_count['full_zero'] += 1
        else:
          output_count['full_nonzero'] += 1
  output = Counter({
    'Prefix Search': float(output_count['prefix_zero'])/(output_count['prefix_nonzero']+output_count['prefix_zero']),
    'Full Search': float(output_count['full_zero'])/(output_count['full_nonzero']+output_count['full_zero']),
  })
  misc.write_counter(output, date, "test.tsv")
