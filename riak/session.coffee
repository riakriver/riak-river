express = require 'express'
riak = require "#{__dirname}/"
async = require 'async'

class RiakSession extends express.session.Store
  constructor: ()->
    @bucket = "_sessions"
    @client = riak.getSessionClient()

  get: (sid, cb)=>
    @client.get @bucket, sid, cb

  set: (sid, session, cb)=>
    @client.save @bucket, sid, session, cb

  destroy: (sid, cb) =>
    @client.remove @bucket, sid, cb

  length: (cb)=>
    @client.count @bucket, cb

  clear: (cb) =>
    batches = 0
    count = 0
    stream = @client.keys @bucket, keys: 'stream'
    stream.on 'keys', (keys)=>
      batches++
      async.each keys, @destroy, -> count++
    stream.on 'end', ->
      check = ->
        if batches is count
          cb()
        else
          setImmediate check
      check()
    stream.start()

module.exports = RiakSession
