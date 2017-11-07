url = require 'url'
path = require 'path'
Crawler = require 'simplecrawler'
{ eachSeries } = require 'async'
chalk = require 'chalk'

driver = require './driver'

module.exports = (config) ->
  testUrl = driver config

  crawlUrl = (crawlUrl, onItem, onComplete) ->
    crawler = Crawler crawlUrl
    urlList = []
    skipExtensions = ['css', 'js', 'png', 'jpg', 'gif', 'svg', 'psd', 'ai', 'zip', 'gz', 'xz', 'pdf']

    crawler.on 'crawlstart', ->
      console.log '\n--- Building sitemap. This might take a bit...\n'

    crawler.on 'queueadd', (queueItem) ->
      urlList.push queueItem.url
      console.log chalk.gray "Added item ##{ queueItem.id } to queue: #{ queueItem.uriPath }"
      onItem queueItem

    crawler.on 'complete', ->
      console.log '\n--- Sitemap completed!\n'
      onComplete urlList

    crawler.addFetchCondition (queueItem) ->
      not skipExtensions.some (ext) ->
        queueItem.path.endsWith ".#{ ext }"

    # Include only URLs with a given string
    if config.include?.length > 0
      crawler.addFetchCondition (queueItem) ->
        config.include.some (str) -> queueItem.path.includes str

    # Exclude any URLs with a given string
    if config.exclude?.length > 0
      crawler.addFetchCondition (queueItem) ->
        not config.exclude.some (str) -> queueItem.path.includes str

    crawler.host = url.parse(crawlUrl).hostname
    crawler.filterByDomain = true
    crawler.stripQuerystring = true
    crawler.downloadUnsupported = false
    crawler.maxConcurrency = 5
    crawler.allowInitialDomainChange = true
    crawler.respectRobotsTxt = false
    crawler.parseHTMLComments = false
    crawler.parseScriptTags = false

    crawler.start()

  onItem = (item) ->
    # Nothing for now...

  onComplete = (urlList) ->
    eachSeries urlList, ((url, callback) ->
      testUrl url, callback
    ), ( ->
      process.exit 0
    )

  crawlUrl config.url, onItem, onComplete
