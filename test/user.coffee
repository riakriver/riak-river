request = require 'request'
should = require 'should'
goodHTML = require './goodHTML'

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

describe 'Users', ->
  before (done) ->
    request host, (e, r, b)->
      if e
        (require __dirname + '/../index') done
      else
        done()


