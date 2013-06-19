/*
 * socket.io configuration
 */
module.exports = function(app, server){
  var io = require('socket.io').listen(server),
    mailchimp = new require('mailchimp')
      .MailChimpAPI(process.env.MAIL_CHIMP_KEY || 'd92a1131ffea8aeada1ac44eceb31d53-us5',
        { version:'1.3', secure:true}
      );
  var appygram = require('appygram');
  appygram.setApiKey('534ee3103753a5a994e39bff405fcf1cb21bef2b');
  io.sockets.on('connection', function(socket){
    socket.on('new subscriber', function(data){
      /*
       * register new user
       * emit success or error event to socket
       */
      data = JSON.parse(data);
      mailchimp.listSubscribe({
        id:'921e9f4aba',
        first_name:data.fname,
        last_name:data.lname,
        email_address:data.email
      }, function(e, r, b){
        if(e){
          socket.emit('error', e.toString());
        } else {
          socket.emit('success');
          appygram.sendFeedback({
            name: data.fname + ' ' + data.lname,
            email:data.email,
            topic:'beta_tester',
            message:'A new beta tester'
          }, function(){
          });
        }
      });
    });
  });

  app.locals.socketio = process.env.SOCKETIO_HOST || 'http://localhost:' + app.get('port');
}
