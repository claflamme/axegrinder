const url = require('url');
const path = require('path');

const AxeBuilder = require('axe-webdriverjs');
const WebDriver = require('selenium-webdriver');
const Phantom = require('phantomjs-prebuilt');
const Crawler = require('simplecrawler');
const chalk = require('chalk');

const csv = require('./csv');

// Custom selenium driver that uses the bundled phantomjs, so we don't need a
// binary in the PATH.
const customPhantom = WebDriver.Capabilities.phantomjs();
customPhantom.set('phantomjs.binary.path', Phantom.path);
const driverTemplate = new WebDriver.Builder().withCapabilities(customPhantom);

module.exports = (argv) => {

  const crawler = Crawler(argv.url);
  const writer = csv(argv.csv);

  crawler.on('crawlstart', () => {
    console.log('\nBuilding initial map. One moment, please...\n');
  });

  crawler.on('complete', () => {
    writer.close();
  });

  crawler.on('fetchstart', (queueItem, requestOptions) => {
    const driver = driverTemplate.build();
    driver.get(queueItem.url).then(() => {
      try {
        AxeBuilder(driver).withTags(['wcag2a', 'wcag2aa']).analyze((results) => {
          if (results.violations.length > 0) {
            console.error(chalk.red('✘ ' + queueItem.url));
            const errors = results.violations.map(v => '  - ' + v.help);
            console.error(chalk.gray(errors.join('\n')));
            if (argv.csv) {
              writer.addViolations(queueItem.url, results.violations);
            }
          } else {
            console.log(chalk.green('✓ ' + queueItem.url));
          }
          driver.quit();
        });
      } catch(e) {
        console.error(chalk.red('Error fetching ' + queueItem.url));
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
  crawler.maxConcurrency = 1;

  crawler.start();

}
