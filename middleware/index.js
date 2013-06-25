exports.requireAuth = function(req, res, next){
  if(req.isAuthenticated()){
    return next();
  }
  res.redirect('/login');
}

exports.requireAuthButNoRedirect = function(req, res, next){
  if(!req.isAuthenticated()){
    return res.send(401);
  }
  next();
}
