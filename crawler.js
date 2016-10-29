const url = require('url');
const path = require('path');

const WebDriver = require('selenium-webdriver');
const Phantom = require('phantomjs-prebuilt');
const Crawler = require('simplecrawler');
const chalk = require('chalk');

const csv = require('./csv');
const download = require('./driver')();

module.exports = (argv) => {

  const crawler = Crawler(argv.url);
  const writer = csv(argv.csv);

  crawler.on('crawlstart', () => {
    console.log('\nBuilding initial map. One moment, please...\n');
  });

  crawler.on('complete', () => {
    writer.close();
  });

  crawler.on('fetchstart', function(queueItem, requestOptions) {
    download(queueItem.url, (err, results) => {
      if (argv.csv && results.violations.length > 0) {
        writer.addViolations(queueItem.url, results.violations);
      }
    });
  });

  // Only include non-file URLs.
  crawler.addFetchCondition((queueItem, referrerQueueItem) => {
    const urlPath = url.parse(queueItem.path).path;
    const urlExt = path.extname(urlPath);
    return urlExt === '' && queueItem.path.includes(argv.include || '');
  });

  crawler.host = url.parse(argv.url).hostname
  crawler.filterByDomain = true;
  crawler.stripQuerystring = true;
  crawler.downloadUnsupported = false;
  crawler.maxConcurrency = 5;

  crawler.start();

}
