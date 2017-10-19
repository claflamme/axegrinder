path = require 'path'
axe = require 'axe-core'
Nightmare = require 'nightmare'
chalk = require 'chalk'

padStr = (str = '', numSpaces = 0) ->
  "#{ ' '.repeat numSpaces }#{ str }"

getXpathsFromNodes = (axeNodesList) ->
  xpaths = []

  axeNodesList.forEach (node) ->
    node.target.forEach (target) ->
      xpaths.push target

  xpaths

# Returns a printable string of bulleted XPaths, each on a new line.
getXpathsString = (xpathsList) ->
  strings = xpathsList.map (xpath) ->
    padStr "- #{ xpath }", 4

  chalk.gray strings.join '\n'

getUrlString = (url, icon, colour) ->
  chalk.bold[colour] "#{ icon } #{ url }\n"

# Returns a printable string with aXe errors and (optionally) xpaths
# for the erroneous nodes. Accepts an aXe "violations" collection.
getErrorsString = (axeErrors, severityLabel, colour) ->
  violations = axeErrors.map (v) ->
    nodeTargets = getXpathsFromNodes v.nodes
    label = chalk[colour] "  • [#{ severityLabel }]"
    "#{ label } #{ v.help }\n#{ getXpathsString(nodeTargets) }"

logResults = (url, results) ->
  hasErrors = false

  if results.violations.length > 0
    hasErrors = true
    console.error getUrlString url, '✘', 'red'
  else if results.incomplete.length > 0
    hasErrors = true
    console.log getUrlString url, '?', 'yellow'
  else
    console.log getUrlString url, '✓', 'green'

  if hasErrors
    violations = getErrorsString results.violations, 'violation', 'red'
    incomplete = getErrorsString results.incomplete, 'incomplete', 'yellow'
    console.error [violations..., incomplete...].join('\n'), '\n'

module.exports = ->
  testWindow = Nightmare()

  # The SIGINT (ctrl + c) event doesn't work natively on windows at the process
  # level, but you can still catch the readline event.
  if process.platform is 'win32'
    rl = require('readline').createInterface
      input: process.stdin
      output: process.stdout
    rl.on 'SIGINT', -> process.emit 'SIGINT'

  # If the process is prematurely terminated, the electron instance will get
  # orphaned and stay in memory. Gotta shut it down here. Nightmare will kill
  # electron if `process.exit()` is called normally.
  process.on 'SIGINT', ->
    testWindow.end().then ->
    process.exit()

  (url, callback) ->
    testWindow.goto(url)
    .inject('js', path.join(__dirname, 'node_modules', 'axe-core', 'axe.js'))
    .evaluate((done) -> axe.run done)
    .then(
      (results) ->
        logResults url, results
        callback null
    )
    .catch callback
