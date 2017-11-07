commander = require 'commander'
chalk = require 'chalk'
crawler = require './crawler'

crawlerUrl = null
validTags = ['wcag2a', 'wcag2aa', 'section508', 'best-practice']

collectFilters = (filterString, filtersList) ->
  filtersList.push filterString
  return filtersList

parseTags = (tagStr) ->
  return tagStr.split(',').map (str) -> str.trim()

commander
.usage '[options] <url>'
.description 'Crawls a website and reports accessibility issues for each page.'
.option '-c, --csv <filepath>', 'path to CSV output file'
.option '-i, --include [string]', 'include only URLs containing this string', collectFilters, []
.option '-e, --exclude [string]', 'exclude any URLs containing this string', collectFilters, []
.option '-t, --tags <string>', "comma-separated list of rule tags (#{ validTags.join(',') })", parseTags, 'wcag2aa'
.parse process.argv

unless commander.args[0]
  commander.help()

crawler
  url: commander.args[0]
  csv: commander.csv,
  include: commander.include
  exclude: commander.exclude
  tags: commander.tags
