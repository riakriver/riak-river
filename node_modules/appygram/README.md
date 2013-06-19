Appygram-node
=============

An Appygram connector


##Build Status

[![Build
Status](https://secure.travis-ci.org/wlaurance/appygram-node.png)](http://travis-ci.org/wlaurance/appygram-node)

##Usage

### Express
```javascript
  var appygram = require('appygram');
  ...
  //Make sure to use app.router; otherwise this middleware will not work
  app.use(app.router);
  appygram.setApiKey('your_api_key');
  app.use(appygram.errorHandler);
```

appygram lets you add a user object to the trace it sends. It defaults
to not sending a user object. To enable do
```javascript
appygram.include_user = true;
```
It defaults to the location of `req['user']`. To change this do
```javascript
appygram.user_location = "user_session_obj"
```
*Note* appygram only will support the user location if it is in the req
object.

To change the 'software' set with a trace object do
```javascript
appygram.app_name = "my awesome express app"
```
Otherwise it will default to "node application"

If you need to reset the appygram object for some reason a method is
exposed to handle this for you.
```javascript
appygram.reset_to_default();
```
You can see some basic examples here.

[Example app](https://github.com/wlaurance/appygram-express-test-project)

###Basic sendFeedback Method
```javascript
  var appygram = require('appygram');
  appygram.setApiKey('api_key');
  appygram.sendFeedback({
   name:'Will',
   topic:'Feedback',
   message:'I am sending an appygram!',
   email:'w.laurance@gmail.com'
  }, function(){
    //done sending feedback
  });
```
Most of the options for the express route are available to this method
with the exception of the include user option.
