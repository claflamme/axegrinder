path = require 'path'
axe = require 'axe-core'
Nightmare = require 'nightmare'
chalk = require 'chalk'

getNodeTargets = (axeNodesList) ->
  nodeTargets = []

  axeNodesList.forEach (node) ->
    node.target.forEach (target) ->
      nodeTargets.push "    - #{ target }"

  nodeTargets

getUrlString = (url, icon, colour) ->
  chalk.bold[colour] "#{ icon } #{ url }\n"

logResults = (url, results) ->
  if results.violations.length > 0
    console.error getUrlString url, '✘', 'red'
  else if results.incomplete.length > 0
    console.log getUrlString url, '?', 'yellow'
  else
    console.log getUrlString url, '✓', 'green'

  violations = results.violations.map (v) ->
    nodeTargets = getNodeTargets v.nodes
    label = chalk.red "  • [violation]"
    "#{ label } #{ v.help }\n#{ chalk.gray nodeTargets.join('\n') }"

  incomplete = results.incomplete.map (i) ->
    nodeTargets = getNodeTargets i.nodes
    label = chalk.yellow "  • [incomplete]"
    "#{ label } #{ i.help }\n#{ chalk.gray nodeTargets.join('\n') }"

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
