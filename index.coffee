express = require 'express'
http = require 'http'
app = do express
ready = undefined
appygram = require 'appygram'
passport = require 'passport'
RiakSession = require "#{__dirname}/riak/session"

glog = (require 'glog') "#{__dirname}/blog_repo"
blog = require "#{__dirname}/blog"
user = require "#{__dirname}/user"

app.set 'view engine', 'jade'
app.locals = require './locals'
app.use express.cookieParser()
app.use express.bodyParser()
app.use (req,res,next)->
  res.locals.path = req.path
  next()
app.use express.static __dirname + '/public'
app.use express.session
  secret: 'keyboard cat'
  store: new RiakSession()
app.use passport.initialize()
app.use passport.session()
app.use (req, res, next)=>
  res.locals.loggedIn = req.user?
  next()
app.use app.router
app.use (req, res, next)->
  res.status 404
  res.render '404', url: req.url
appygram.setApiKey 'b3cdfe0ab93467a314652f70504d19468c5de524'
appygram.app_name = 'riak-river'
if process.env.NODE_ENV?.toLowerCase() is 'production'
  app.use appygram.errorHandler

app.get '/', (req, res) ->
  res.render 'index'

app.get '/contact', (req, res)->
  res.render 'contact'

app.post '/contact', (req, res)->
  res.redirect '/'
  if process.env.NODE_ENV?.toLowerCase() is 'production'
    process.nextTick ->
      req.body.topic = 'Feedback'
      appygram.sendFeedback req.body

blog app, glog
user app, passport

port = process.env.PORT || 3000

(http.createServer app).listen port, ->
  ready() if ready

module.exports = (done) ->
  ready = done
