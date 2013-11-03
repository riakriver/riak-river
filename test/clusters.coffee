request = require 'request'
should = require 'should'
goodHTML = require './goodHTML'

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

describe 'Clusters', ->
  cookie = null
  before (done) ->
    getCookie = ->
      request.post "#{host}/login",
        form:
          email: 'w.laurance@gmail.com'
          password: 'password'
        , (e,r,b)->
          cookie = r.headers['set-cookie']
          done()
    request host, (e, r, b)->
      if e
        (require __dirname + '/../index') getCookie()
      else
        getCookie()

  it 'should have a /account/clusters page', (done)->
    request.get "#{host}/account/clusters",
      headers:
        Cookie: cookie
      followRedirect: no
    , (e,r,b)->
      goodHTML r, done


