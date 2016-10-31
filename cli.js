#!/usr/bin/env node

const yargs = require('yargs');

const crawler = require('./crawler');

yargs
.command('crawl <url>', 'Crawl a website for issues, starting at the given URL.', {
  include: {
    describe: 'A string that URLs must include to be crawled.',
  },
  csv: {
    describe: 'Dump output to a CSV file at the specified path.'
  }
}, crawler)
.help()
.argv;
