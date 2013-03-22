var m = require(__dirname + '/../middleware');
module.exports = function(app){
  app.get('/account', m.requireAuth, function(req, res){
    res.render('account', {user:req.user});
  });
}
