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

  it 'has a login page', (done)->
    request "#{host}/login", (e,r,b)-> goodHTML r, done

  describe 'accounts', ->
    before (done)->
      request.post "#{host}/signup",
        form:
          email: 'w.laurance@gmail.com'
          password: 'password'
        , (e,r,b)->
          r.statusCode.should.be.equal 302
          r.headers.location.should.be.equal '/account'
          r.headers['set-cookie'].should.have.property 'length', 1
          done()
    it 'can post login info to itself', (done)->
      request.post "#{host}/login",
        form:
          email: 'w.laurance@gmail.com'
          password: 'password'
        , (e,r,b)->
          r.statusCode.should.be.equal 302
          r.headers.location.should.be.equal '/account'
          r.headers['set-cookie'].should.have.property 'length', 1
          done()

    it 'redirects if already logged in', (done)->
      request.post "#{host}/login",
        form:
          email: 'w.laurance@gmail.com'
          password: 'password'
      , (e,r,b)->
        request "#{host}/login",
          headers:
            Cookie: r.headers['set-cookie']
          followRedirect: no
        , (e,r,b)->
          r.statusCode.should.be.equal 302
          r.headers.location.should.be.equal '/account'
          done()

