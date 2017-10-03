path = require 'path'
axe = require 'axe-core'

{ BrowserWindow, ipcMain } = require 'electron'

module.exports = ->
  testWindow = new BrowserWindow {
    width: 1280
    height: 900
    show: false
    webPreferences:
      preload: path.join __dirname, 'injection.js'
  }

  (url, callback) ->
    testWindow.loadURL url

    testWindow.webContents.once 'did-finish-load', ->
      testWindow.webContents.send 'driver-start-analysis', url

    ipcMain.once 'driver-done-analysis', (event, url, results) ->
      console.log results
      callback null
