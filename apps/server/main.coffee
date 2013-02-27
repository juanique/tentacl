nodeStatic = require 'node-static'

routes = (app) ->

  fileServer = new nodeStatic.Server app.settings.fsRoot,
    cache: 600
    headers: { 'X-Powered-By': 'node-static'}

  app.get /\/fs\/(.+)/, (req, res) ->
    path = req.params[0]
    fileServer.serveFile path, 200, {}, req, res

module.exports = routes
