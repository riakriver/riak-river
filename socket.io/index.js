/*
 * socket.io configuration
 */
module.exports = function(app, server){
  var io = require('socket.io').listen(server),
    mailchimp = new require('mailchimp')
      .MailChimpAPI(process.env.MAIL_CHIMP_KEY || 'd92a1131ffea8aeada1ac44eceb31d53-us5',
        { version:'1.3', secure:true}
      );

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
        }
      });
    });
  });

  app.locals.socketio = process.env.SOCKETIO_HOST || 'http://localhost:' + app.get('port');
}
