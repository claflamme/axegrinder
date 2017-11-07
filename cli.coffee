commander = require 'commander'
crawler = require './crawler'

crawlerUrl = null

# crawlerOpts =
#   include:
#     describe: 'A string that URLs must include to be crawled.'
#   csv:
#     describe: 'Dump output to a CSV file at the specified path.'
#   levels:
#     describe: 'Comma-separated list of accessibility levels to enforce.'
#     default: 'wcag2a,wcag2aa'

collectFilters = (filterString, filtersList) ->
  filtersList.push filterString
  return filtersList

commander
.usage '[options] <url>'
.description 'Crawls a website and reports accessibility issues for each page.'
.option '-c, --csv <filepath>', 'path to CSV output file'
.option '-i, --include <string>', 'include only URLs containing this string (can use multiple times)', collectFilters, []
.option '-e, --exclude [string]', 'exclude any URLs containing this string (can use multiple times)', collectFilters, []
.parse process.argv

unless commander.args[0]
  commander.help()

crawler
  url: commander.args[0]
  csv: commander.csv,
  include: commander.include
  exclude: commander.exclude
