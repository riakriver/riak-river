var ops = [{name:'Feedback'}, {name:'Question'}, {name:'Issue'}];
var appygram = require('appygram');
module.exports = function(app){
  app.get('/contact', function(req, res){
    res.render('contact', {submitted:false, options:ops, user:req.user});
  });
  app.post('/contact', function(req, res){
    appygram.sendFeedback();
    res.render('contact', {submitted:true, options:ops, user:req.user});
  });
}
