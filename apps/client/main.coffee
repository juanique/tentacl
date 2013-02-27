express = require 'express'
assets = require 'connect-assets'

module.exports = (app) ->
  assetsDir = __dirname + '/assets'

  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use assets({
    src: assetsDir
  })
  js.root = 'coffee'
  css.root = 'less'

  app.use express.static(assetsDir)
  app.use express.static(assetsDir + '/extern')

  app.get '/client/', (req, res) ->
    res.render 'home.jade'
  app.get '/client/test/', (req, res) ->
    res.render 'test.jade'
