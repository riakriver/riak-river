module.exports =
  loggedIn: (req, res, next)->
    if req.isAuthenticated()
      next()
    else
      res.redirect '/login'
  alreadyLoggedIn: (req, res, next)->
    if req.user
      res.redirect '/account'
    else
      next()
