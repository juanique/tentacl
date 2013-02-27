express = require 'express'
settings = require './settings'

app = express()
app.settings = settings

require('./apps/server/main')(app)
require('./apps/client/main')(app)

app.listen settings.port
console.log "Server listening on port #{settings.port}"

exports.app = app
