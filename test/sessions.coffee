request = require 'request'
should = require 'should'
goodHTML = require './goodHTML'
async = require 'async'
_ = require 'underscore'
RiakSession = new (require "#{__dirname}/../riak/session")()

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

createNewSession = (nil, cb)->
  request.post "#{host}/login",
    form:
      email: 'w.laurance@gmail.com'
      password: 'password'
    , (e,r,b)->
      cb(e, r.headers['set-cookie'])


describe 'Sessions', ->
  sessions = []
  before (done) ->
    request host, (e, r, b)->
      if e
        (require __dirname + '/../index') done
      else
        done()
  before (done) ->
    @.timeout 60000
    RiakSession.clear done
  it 'creates sessions', (done)->
    @.timeout 60000
    async.map _.range(100), createNewSession, (err, results)->
      sessions = results
      done()
  it 'can get the count', (done)->
    @.timeout 60000
    RiakSession.length (err, length)->
      length.should.be.above 0
      done()

