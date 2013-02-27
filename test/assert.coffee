assert = module.exports = require 'assert'

assert.endsWith = (value, suffix) ->
  suffixIndex = Math.max(value.length - suffix.length, 0)
  prefix = value.substring(0, suffixIndex)
  expected = prefix + suffix
  assert.equal(expected, value)
