url = require 'url'
path = require 'path'
Crawler = require 'simplecrawler'
{ eachSeries } = require 'async'

driver = require './driver'
testUrl = driver()

crawlUrl = (crawlUrl, onItem, onComplete) ->
  crawler = Crawler crawlUrl
  urlList = []

  crawler.on 'crawlstart', ->
    console.log '\n--- Building sitemap. One moment, please...\n'

  crawler.on 'queueadd', (queueItem) ->
    urlList.push queueItem.url
    console.log "Added item ##{ queueItem.id } to queue: #{ queueItem.uriPath }"
    onItem queueItem

  crawler.on 'complete', ->
    console.log '\n--- Map completed!\n'
    onComplete urlList

  crawler.addFetchCondition (queueItem, referrerQueueItem) ->
    queueItem.path.includes '/en/about'

  crawler.host = url.parse(crawlUrl).hostname
  crawler.filterByDomain = true
  crawler.stripQuerystring = true
  crawler.downloadUnsupported = false
  crawler.maxConcurrency = 5

  crawler.start()

onItem = (item) ->
  console.log item

onComplete = (urlList) ->
  console.log '\n--- Done crawling! Running tests...'
  eachSeries urlList, (url, callback) ->
    testUrl url, callback

module.exports = (argv) ->
  crawlUrl argv.url, onItem, onComplete
