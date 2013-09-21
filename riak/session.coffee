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
    count = (values)=>
      [values.reduce(
        (total, value)=>
          if isNaN(parseInt(value))
            return total + 1
          else
            return total + value
      , 0)]
    @client.mapreduce
      .add(@bucket)
      .map("Riak.mapValues")
      .reduce(count)
      .run(cb)

  clear: (cb) =>
    @client.mapreduce
      .add(@bucket)
      .map((v)-> return [v.key])
      .run (err, keys) =>
        if (err)
          return cb(err)
        async.eachLimit keys, 100, @destroy, cb


module.exports = RiakSession
