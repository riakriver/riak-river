express = require 'express'
http = require 'http'
app = do express
ready = undefined
appygram = require 'appygram'

app.configure ->
  @.set 'view engine', 'jade'
  @.locals = require './locals'
  @.use express.bodyParser()
  @.use (req,res,next)->
    res.locals.path = req.path
    next()
  @.use app.router
  appygram.setApiKey 'b3cdfe0ab93467a314652f70504d19468c5de524'
  appygram.app_name = 'riak-river'

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

app.use express.static __dirname + '/public'

port = process.env.PORT || 3000

(http.createServer app).listen port, ->
  ready() if ready

module.exports = (done) ->
  ready = done
