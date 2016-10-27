#!/usr/bin/env node

const yargs = require('yargs');

yargs.command('crawl <url>', 'Crawl a website for issues.', {
  like: {
    default: '',
    describe: 'A string that URLs must contain to be crawled.',
  }
}, require('./crawler'))
.help()
.argv;
