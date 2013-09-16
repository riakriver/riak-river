LocalStrategy = (require 'passport-local').Strategy
crypto = require 'crypto'
riak = require "#{__dirname}/../riak"

validPassword = (user, password)->
  sha1 = crypto.createDigest 'sha1'
  sha1.update password + user.salt
  user.password is sha1.digest()

santizeUser = (user)->
  user

module.exports = (app, passport)->
  passport.use new LocalStrategy (username, password, done)->
    riak.getClient().get 'users', username, (err, user)->
      return done err if err
      if not user
        return done null, false, message: "#{username} not found."
      if not validPassword user, password
        return done null, false, message: "Invalid password."
      return done null, santizeUser user
