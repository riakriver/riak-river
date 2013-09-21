express = require 'express'
riak = require "#{__dirname}/"

class RiakSession extends express.session.Store
  constructor: ()->
    @bucket = "_sessions"
    @client = riak.getSessionClient()

  get: (sid, cb)->
    @client.get @bucket, sid, cb

  set: (sid, session, cb)->
    @client.save @bucket, sid, session, cb

  destroy: (sid, cb)->

  length: (cb)->

  clear: (cb)->

module.exports = RiakSession
