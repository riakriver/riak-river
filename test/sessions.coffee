request = require 'request'
should = require 'should'
goodHTML = require './goodHTML'

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

describe 'Sessions', ->
  before (done) ->
    request host, (e, r, b)->
      if e
        (require __dirname + '/../index') done
      else
        done()
  it 'creates session', (done)->
    request.post "#{host}/login",
      form:
        email: 'w.laurance@gmail.com'
        password: 'password'
      , (e,r,b)->
        r.statusCode.should.be.equal 302
        r.headers.location.should.be.equal '/account'
        r.headers['set-cookie'].should.have.property 'length', 1
        done()
