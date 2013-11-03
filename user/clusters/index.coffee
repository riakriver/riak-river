utils = require "#{__dirname}/../utils"

ns = "/account/clusters"

module.exports = (app)->
  app.get "#{ns}", utils.loggedIn, (req, res)->
    res.render 'clusters/new'
