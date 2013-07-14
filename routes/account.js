var m = require(__dirname + '/../middleware');
module.exports = function(app){
  app.get('/account', m.requireAuth, function(req, res){
    console.log(req.user);
    res.render('account', {user:req.user});
  });
}
