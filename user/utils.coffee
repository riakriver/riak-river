module.exports =
  loggedIn: (req, res, next)->
    console.log req.headers
    if req.isAuthenticated()
      next()
    else
      res.redirect '/login'
