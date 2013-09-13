express = require 'express'
http = require 'http'
app = do express
ready = undefined


app.get '/', (req, res) ->
  res.send 200


port = process.env.PORT || 3000

(http.createServer app).listen port, ->
  console.log 'hi'
  ready() if ready

module.exports = (done) ->
  ready = done
