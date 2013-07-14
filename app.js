/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , http = require('http')
  , path = require('path')
  , passport = require('passport')
  , requireAuthButNoRedirect = require('./middleware').requireAuthButNoRedirect
  , fs = require('fs')
  , coffee = require('coffee-script')
  , _ = require('underscore');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('title', 'Riak-River - Riak Cloud Hosting');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.session({
    store: new (require('connect-redis')(express))({
      ttl: 60 * 60 * 24 * 7,
      host: process.env.RIAK_RIVER_REDIS_HOST || '127.0.0.1',
    }),
    secret:process.env.SESSION_SECRET || 'keyboard cat'
  }));
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  app.use(require('stylus').middleware(__dirname + '/public'));

  app.use('/jam', express.static(path.join(__dirname, 'jam')));
});

app.locals.title = app.get('title');

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/sitemap.xml', require('./seo/sitemap'));

require('./authorization')(app, passport);
require('./routes/account')(app);
require('./routes/contact')(app);
require('./routes/subscribe')(app);

/*
 * Apply static app.use last so we can intercept the /public/javascripts/user
 * javacripts and add authentication.
 */
app.get('/javascripts/user/*', function(req, res){
  var handler = function(err, data){
    if (err)
      return res.send(404);
    else {
      res.send(coffee.compile(data.toString()));
    }
  };
  var url = req.url.split('/');
  var csPath = _.rest(url, _.indexOf(url, 'user')).join('/').replace('.js', '.coffee');
  fs.readFile('coffee/' + csPath, handler);
});

app.use(express.static(path.join(__dirname, 'public')));

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
  if(typeof ready === 'function') ready();
});

var ready;
module.exports = function(done){ ready = done };
