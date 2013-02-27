fs = require 'fs'

testing = module.exports

testing.writeTestFile = (filename, contents, callback) ->
  stream = fs.createWriteStream filename
  stream.once 'open', (fd) ->
    stream.write(contents)
    stream.end()
    callback()
