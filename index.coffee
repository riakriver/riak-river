express = require 'express'
http = require 'http'
app = do express
ready = undefined

app.configure ->
  @.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'index'

app.use express.static __dirname + '/public'

port = process.env.PORT || 3000

(http.createServer app).listen port, ->
  ready() if ready

module.exports = (done) ->
  ready = done
