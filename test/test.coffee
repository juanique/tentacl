assert = require './assert'
path = require 'path'
request = require 'supertest'
testing = require './testing'
settings = require ('../settings')
app = require('../server').app

before ->
  settings.fsRoot = path.resolve(__dirname, 'testing-fs')

describe 'Test framework', ->
  console.log settings.fsRoot
  it 'correctly configures the file server path', ->
    assert.endsWith(app.settings.fsRoot, 'testing-fs')

describe 'GET /fs/...', ->

  textFile = path.resolve(settings.fsRoot, 'a-text-file.txt')
  content = 'Homer Simpson'

  before (done) ->
    testing.writeTestFile textFile, content, done

  it 'gets the content of the requested file', (done) ->
    request(app).get('/fs/a-text-file.txt').expect(content, done)

  it 'returns 404 on a missing file', (done) ->
    request(app).get('fs/missing-file.txt').expect(404, done)
