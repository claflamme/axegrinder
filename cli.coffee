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

commander
.command '* <url>'
.description 'Crawls a website and reports accessibility issues for each page.'
.action (url) ->
  crawlerUrl = url

commander.parse process.argv

unless crawlerUrl
  commander.help()

crawler { url: crawlerUrl }
