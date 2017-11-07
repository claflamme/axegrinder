fs = require 'fs'
stringify = require('csv').stringify

csvOpts =
  columns: ['URL', 'Level', 'Issue']
  quotedString: true

writeLine = (outputFile, data, csvOpts) ->
  stringify data, csvOpts, (err, output) ->
    fs.appendFileSync outputFile, output, { encoding: 'utf8' }

module.exports = (filepath) ->
  unless filepath
    return

  outputFile = fs.openSync filepath, 'w'

  writeLine outputFile, [], Object.assign({}, csvOpts, { header: true })

  addViolations: (url, violations, level) ->
    data = violations.map (v) -> [url, level, v.help]
    writeLine outputFile, data, csvOpts

  close: ->
    fs.closeSync outputFile
