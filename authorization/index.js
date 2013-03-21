var Github = require('passport-github').Strategy;
module.exports = function(app, passport){
  passport.serializeUser(function(user, done){
    done(null, user);
  });

  passport.deserializeUser(function(obj, done){
    done(null, obj);
  });

  passport.use(new Github({
    clientID: process.env.GITHUB_CLIENT_ID || '6a0d645fa20b73e8600a',
    clientSecret: process.env.GITHUB_CLIENT_SECRET || 'a87f0d73a5fca45ad20cccbc3ec54acc89c172e2',
    callbackURL: process.env.GITHUB_CALLBACK_URL  || 'http://localhost:3000/auth/github/callback'
    }, function(accessToken, refreshToken, profile, done){
      process.nextTick(function(){
        done(null, profile);
      });
    })
  );

  app.get('/auth/github', passport.authenticate('github'), function(req, res){

  });

  app.get('/auth/github/callback', passport.authenticate('github', {failureRedirect: '/login'}), function(req, res){ res.redirect('/account'); });

  app.get('/login', function(req, res){
    if(req.isAuthenticated()){
      res.redirect('/account');
    } else {
      res.render('login', {strategies:['github']});
    }
  });

  app.get('/logout', function(req, res){
    req.logout();
    res.redirect('/');
  });
};
