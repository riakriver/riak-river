LocalStrategy = (require 'passport-local').Strategy
crypto = require 'crypto'
riak = require "#{__dirname}/../riak"
utils = require "#{__dirname}/utils"
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
      , (err, user, meta)->
        if not err
          req.login req.body.email, (err)->
            res.redirect '/account'

  app.get '/login', utils.alreadyLoggedIn, (req, res)->
    res.render 'login'

  app.get '/signup', utils.alreadyLoggedIn, (req, res)->
    res.render 'signup'

  app.get '/logout', (req, res)->
    req.logout()
    res.redirect '/'

  app.get '/account', utils.loggedIn, (req, res)->
    res.render 'account', user: req.user
