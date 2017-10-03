{ ipcRenderer } = require './electron'

axe = require 'axe-core'

ipcRenderer.on 'driver-start-analysis', (event, url) ->
  axe.run (err, results) ->
    event.sender.send 'driver-done-analysis', url, results
