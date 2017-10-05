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

logResults = (url, results) ->

  if results.violations.length > 0
    console.error chalk.bold.red '✘ ' + url
  else if results.incomplete.length > 0
    console.log chalk.bold.yellow '? ' + url
  else
    console.log chalk.bold.green '✓ ' + url

  violations = results.violations.map (v) ->
    nodeTargets = getNodeTargets v.nodes
    "  [violation] #{ v.help }\n#{ chalk.gray nodeTargets.join('\n') }"

  incomplete = results.incomplete.map (i) ->
    nodeTargets = getNodeTargets i.nodes
    "  [incomplete] #{ i.help }\n#{ chalk.gray nodeTargets.join('\n') }"

  console.error [violations..., incomplete...].join('\n'), '\n'

module.exports = ->
  testWindow = Nightmare()

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
