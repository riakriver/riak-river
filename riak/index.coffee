riakjs = require 'riak-js'

module.exports =
  getClient: ->
    servers = []
    if process.env.NODE_ENV?.toLowerCase() is 'production'
      servers.push 'riak.riakriver.com:8098'
    else
      servers.push 'zimbo.local:8098'
    riakjs.getClient
      pool:
        servers: servers
