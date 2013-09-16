riakjs = require 'riak-js'

module.exports = ->
  servers = []
  if process.env.NODE_ENV?.toLowerCase() is 'production'
    servers.push 'riak.riakriver.com:8098'
  else
    servers.push 'krumm.local:8098'
  riakjs.createClient
    pool:
      servers: servers
