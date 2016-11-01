# Axegrinder

An all-in-one tool for running [aXe](https://www.deque.com/products/axe/) accessibility tests on several pages (or entire websites) at once. It bundles Selenium WebDriver, aXe, and PhantomJS into a tidy lil' CLI.

> This tool is for flagging problematic pages. For detailed page info, try one of the aXe browser plugins.
>
> 👉 [Chrome](https://chrome.google.com/webstore/detail/axe/lhdoppojpmngadmnindnejefpokejbdd) 👉 [Firefox](https://addons.mozilla.org/en-us/firefox/addon/axe-devtools/)

![preview animation](http://i.imgur.com/BOYkHfu.gif)

## Installation

```
npm i axegrinder -g
```

Axegrinder is a node.js package so you'll need [node and npm installed](https://nodejs.org/en/). If you don't have node installed already, you're probably the only one.

## Usage

For now, axegrinder only has one command: `crawl`. You can point the tool at a URL and it will do its best to go through the entire website until it runs out of new links.

```
axegrinder crawl https://nodejs.org
```

This will output the results of the crawl to the terminal, in a nicely formatted list. Pages with accessibility violations will be highlighted in red.

### CSV Output

Of course, it would be much more useful to save your results to a spreadsheet. By using the `--csv` arg, axegrinder can log each violation along with the URL of the page on which it was found.

```
axegrinder crawl https://nodejs.org --csv=output.csv
```

If you abort the crawl early, your results up to that point will still be saved to the CSV file.

### Accessibility Standards

Since axegrinder is just a wrapper around aXe, you can use any of the aXe "tags" to specify which standards to validate against. You can set multiple standards at once, as a comma-separated list:

```
axegrinder crawl http://nodejs.org --levels=wcag2a,wcag2aa
```

The available options are listed below. I think the names are pretty self-explanatory, but you can check the aXe docs if you want specifics.

- `wcag2a`
- `wcag2aa`
- `section508`
- `best-practice`

### Filter URLs

You can include only pages whose URL contains a specific string. Just use the `--include` arg.

```
axegrinder crawl https://nodejs.org --include=/url/pattern
```
