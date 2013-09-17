LocalStrategy = (require 'passport-local').Strategy
crypto = require 'crypto'
riak = require "#{__dirname}/../riak"
_ = require 'underscore'

validPassword = (user, password)->
  sha1 = crypto.createHash 'sha1'
  sha1.update password + user.salt
  user.password is sha1.digest 'hex'

genPassword = (password)->
  salt = new Date().toJSON()
  sha1 = crypto.createHash 'sha1'
  sha1.update password + salt
  return {
    password: sha1.digest 'hex'
    salt: salt
  }

santizeUser = (user)->
  rm = (k)-> delete user[k]
  _.each ['password', 'salt'], rm
  user

module.exports = (app, passport)->
  passport.use new LocalStrategy usernameField: 'email', (username, password, done)->
    riak.getClient().get 'users', username, (err, user)->
      return done err if err
      if not user
        return done null, false, message: "#{username} not found."
      if not validPassword user, password
        return done null, false, message: "Invalid password."
      return done null, santizeUser user

  passport.serializeUser (user, done)->
    done null, user.email

  passport.deserializeUser (id, done)->
    riak.getClient(). get 'users', id, done

  app.post '/login', passport.authenticate 'local',
    successRedirect: '/account'
    failureRedirect: '/login'

  app.post '/signup', (req, res)->
    secret = genPassword req.body.password
    riak.getClient().save 'users', req.body.email,
      email: req.body.email
      password: secret.password
      salt: secret.salt
      , (err)->
        res.send err.statusCode, err if err
        res.send 200 if not err

  app.get '/login', (req, res)->
    res.render 'login'
