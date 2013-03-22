var ops = [{name:'Feedback'}, {name:'Question'}, {name:'Issue'}];
var appygram = require('appygram');
appygram.setApiKey('534ee3103753a5a994e39bff405fcf1cb21bef2b');
module.exports = function(app){
  app.get('/contact', function(req, res){
    res.render('contact', {submitted:false, options:ops, user:req.user});
  });
  app.post('/contact', function(req, res){
    appygram.sendFeedback({
      name:req.body.fname + ' ' + req.body.lname,
      email:req.body.email,
      message:req.body.feedback,
      topic:'Feedback'
    }, function(){
      res.render('contact', {submitted:true, options:ops, user:req.user});
    });
  });
}
