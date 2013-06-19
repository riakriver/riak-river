/*
 * subscribe configuration
 */
module.exports = function(app){
  var mailchimp = new require('mailchimp')
      .MailChimpAPI(process.env.MAIL_CHIMP_KEY || 'd92a1131ffea8aeada1ac44eceb31d53-us5',
        { version:'1.3', secure:true}
      );
  var appygram = require('appygram');
  appygram.setApiKey('534ee3103753a5a994e39bff405fcf1cb21bef2b');
  app.post('/subscribe', function(req, res){
      /*
       * register new user
       * send success or error response
       */
    var data = req.body;
    mailchimp.listSubscribe({
      id:'921e9f4aba',
      first_name:data.fname,
      last_name:data.lname,
      email_address:data.email
    }, function(e, r, b){
      if(e){
        res.send({error: e.toString()});
      } else {
        res.send(200);
        process.nextTick(function(){
          appygram.sendFeedback({
            name: data.fname + ' ' + data.lname,
            email:data.email,
            topic:'beta_tester',
            message:'A new beta tester'
          });
        });
      }
    });
  });
}
