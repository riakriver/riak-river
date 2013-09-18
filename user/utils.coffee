module.exports =
  loggedIn: (req, res, next)->
    if req.isAuthenticated()
      next()
    else
      res.redirect '/login'
