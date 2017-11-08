# Axegrinder

Axegrinder is a command-line tool for developers that crawls websites and runs [aXe](https://www.axe-core.org) accessibility tests on every page it finds. Tests are run in a headless chromium instance—the real deal.

> This tool is only meant to find and flag problematic pages. For detailed (and interactive) results, try one of the aXe browser plugins.
>
> 👉 [Chrome](https://chrome.google.com/webstore/detail/axe/lhdoppojpmngadmnindnejefpokejbdd) 👉 [Firefox](https://addons.mozilla.org/en-us/firefox/addon/axe-devtools/)

## Installation

Axegrinder is a node.js package so you'll need [node and npm installed](https://nodejs.org). You can install the package globally and run it from the command line.

```shell
npm i axegrinder -g
```

## Reference

Further explanations of all the options can be found below.

```shell
Usage: axegrinder [options] <url>

Crawls a website and reports accessibility issues for each page.


Options:

  -c, --csv <filepath>    path to CSV output file
  -i, --include [string]  include only URLs containing this string
  -e, --exclude [string]  exclude any URLs containing this string
  -t, --tags <string>     comma-separated list of rule tags (wcag2a,wcag2aa,section508,best-practice)
  -x, --xpaths            show xpaths in console results
  -h, --help              output usage information
```

## Basic Usage

Point axegrinder at a URL and it will do its best to find and test as many pages as possible.

```shell
axegrinder https://nodejs.org
```

First, it will build a map of the site by crawling as much as it can. Once that's done, it will run through every page and execute a battery of accessibility tests in a headless browser.

Results logged to the terminal will either be a pass (in green), or contain a list of violations (in red). If aXe was unable to complete certain tests, those will be marked as "incomplete" (highlighted in yellow).

## Options

### -c, --csv

Of course, it's not super useful to get results in the command line. For a more permanent results set, use the `--csv` option.

```shell
axegrinder crawl https://nodejs.org --csv=path/to/output.csv
```

Axegrinder will log each violation or incomplete test, along with the URL of the page that caused it. If you abort the crawl early, your results up to that point will still be saved to the CSV file.

### -t, --tags

Since axegrinder is a wrapper around aXe, you can use any of the aXe "tags" to specify which tests to run.

```shell
axegrinder crawl http://nodejs.org --tags=wcag2a,wcag2aa
```

Note that you can set multiple tags at once, as a comma-separated list. By default, axegrinder sets this option to `wcag2aa` (AA compliance).

The available options are listed below. The names are pretty self-explanatory, but you can [check the aXe docs](https://github.com/dequelabs/axe-core/blob/develop/doc/rule-descriptions.md) for specifics.

- `wcag2a`
- `wcag2aa`
- `section508`
- `best-practice`

### -i, --include

Odds are pretty good that you don't want to test your entire site all at once. You can use the `--include` arg to only include pages that have a specific string in the URL.

```shell
# Only scan pages with "/en/about" in the URL
axegrinder crawl https://nodejs.org --include=/en/about
```

This option can be used multiple times to specify several strings.

### -e, --exclude

This works the opposite way that the "include" option works. Use `--exclude` to ignore pages that have a given string in their URL.

```shell
# Skip any pages with "/blog" in the URL
axegrinder crawl https://nodejs.org --exclude=/blog
```

This option can be used multiple times to specify several strings.

### -x, --xpaths

If you'd like to include the xpaths for nodes that triggered violations, you can do so with the `--xpaths` flag. Adding this flag causes lists of xpaths to show up in your results.

```shell
axegrinder crawl https://nodejs.org --xpaths
```

This can be useful for a quick idea of how many specific issues your pages have, but I very much advise against using it for any serious debugging. The [official aXe browser extensions](https://www.axe-core.org) are specifically built for that purpose and do an infinitely better job.

### -h, --help

Print out the handy-dandy help dialogue, as seen in the Reference section.

```shell
axegrinder --help
```
