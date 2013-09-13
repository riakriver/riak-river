request = require 'request'
should = require 'should'

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

goodHTML = (r, cb)->
  r.statusCode.should.be.equal 200
  should.notEqual (r.headers['content-type'].indexOf 'text/html'), -1
  cb() if cb

describe 'Base Routes', ->
  before (done) ->
    request host, (e, r, b)->
      if e
        (require __dirname + '/../index') done
      else
        done()

  it 'have index at /', (done)->
    request "#{host}/", (e,r,b)-> goodHTML r, done

