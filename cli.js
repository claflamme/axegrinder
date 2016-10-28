#!/usr/bin/env node

const yargs = require('yargs');

yargs.command('crawl <url>', 'Crawl a website for issues.', {
  include: {
    describe: 'A string that URLs must include to be crawled.',
  },
  csv: {
    describe: 'Dump output to a CSV file at the specified path.'
  }
}, require('./crawler'))
.help()
.argv;
