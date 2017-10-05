yargs = require 'yargs'
crawler = require './crawler'

crawlerOpts =
  include:
    describe: 'A string that URLs must include to be crawled.'
  csv:
    describe: 'Dump output to a CSV file at the specified path.'
  levels:
    describe: 'Comma-separated list of accessibility levels to enforce.'
    default: 'wcag2a,wcag2aa'

yargs
.command(
  'crawl <url>',
  'Crawl a website for issues, starting at the given URL.',
  crawlerOpts,
  crawler,
)
.help()
.showHelpOnFail(true)
.demandCommand(1, '')
.argv
