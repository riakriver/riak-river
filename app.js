
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , http = require('http')
  , path = require('path');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('stylus').middleware(__dirname + '/public'));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

/*
 * socket.io configuration
 */
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
