should = require 'should'

module.exports = (r, cb)->
  r.statusCode.should.be.equal 200
  should.notEqual (r.headers['content-type'].indexOf 'text/html'), -1
  cb() if cb

