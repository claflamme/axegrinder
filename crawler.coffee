url = require 'url'
path = require 'path'
Crawler = require 'simplecrawler'
{ eachSeries } = require 'async'
chalk = require 'chalk'

driver = require './driver'
testUrl = driver()

crawlUrl = (crawlUrl, onItem, onComplete) ->
  crawler = Crawler crawlUrl
  urlList = []
  urlPath = url.parse(crawlUrl).path

  crawler.on 'crawlstart', ->
    console.log '\n--- Building sitemap. This might take a bit...\n'

  crawler.on 'queueadd', (queueItem) ->
    urlList.push queueItem.url
    console.log chalk.gray "Added item ##{ queueItem.id } to queue: #{ queueItem.uriPath }"
    onItem queueItem

  crawler.on 'complete', ->
    console.log '\n--- Sitemap completed!'
    onComplete urlList

  crawler.addFetchCondition (queueItem, referrerQueueItem) ->
    queueItem.path.includes urlPath

  crawler.host = url.parse(crawlUrl).hostname
  crawler.filterByDomain = true
  crawler.stripQuerystring = true
  crawler.downloadUnsupported = false
  crawler.maxConcurrency = 5
  crawler.allowInitialDomainChange = true

  crawler.start()

onItem = (item) ->
  # Nothing for now...

onComplete = (urlList) ->
  console.log '--- Running tests...\n'
  eachSeries urlList, ((url, callback) ->
    testUrl url, callback
  ), ( ->
    console.log '--- Tests complete!\n'
    process.exit 0
  )

module.exports = (argv) ->
  crawlUrl argv.url, onItem, onComplete
