request = require 'request'
should = require 'should'

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

goodHTML = (r, cb)->
  r.statusCode.should.be.equal 200
  r.headers['content-type'].should.be.equal 'text/hmtl'
  cb() if cb

describe 'Base Routes', ->
  before (done) ->
    (require __dirname + '/../index') done

  it 'have index at /', (done)->
    request "#{host}/", (e,r,b)-> goodHTML r, done



