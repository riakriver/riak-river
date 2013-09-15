request = require 'request'
should = require 'should'
goodHTML = require './goodHTML'

host = "http://127.0.0.1:#{process.env.PORT or 3000}"

describe 'Base Routes', ->
  before (done) ->
    request host, (e, r, b)->
      if e
        (require __dirname + '/../index') done
      else
        done()

  it 'have index at /', (done)->
    request "#{host}/", (e,r,b)-> goodHTML r, done

  describe 'Contact', ->

    it 'has a contact page', (done)->
      request "#{host}/contact", (e,r,b)-> goodHTML r, done

    it 'can post information to its self', (done)->
      request.post "#{host}/contact",
        form:
          name: 'Will'
          email: 'w.laurance@gmail.com'
          message: 'I love your service. It handles my
                    thousand node cluster like nothing else!'
        , (e,r,b)->
          r.statusCode.should.be.equal 302
          done()

  describe 'Blog', ->

    it 'has a blog', (done)->
      request "#{host}/blog", (e,r,b)-> goodHTML r, done

  it 'formats a nice 404 page', (done)->
    request "#{host}/not-a-page-or-resource", (e,r,b)->
      r.statusCode.should.be.equal 404
      should.notEqual (r.headers['content-type'].indexOf 'text/html'), -1
      done()

