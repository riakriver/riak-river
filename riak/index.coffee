riakjs = require 'riak-js'

servers = ->
  serversPool = []
  if process.env.NODE_ENV?.toLowerCase() is 'production'
    serversPool.push 'riak.riakriver.com:8098'
  else
    for port in [10001..10005]
      serversPool.push "localhost:#{port}"
  serversPool

module.exports =
  getClient: ->
    riakjs.getClient
      pool:
        servers: servers()

  getSessionClient: ->
    riakjs.getClient
      pool:
        servers: servers()

