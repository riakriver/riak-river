var tako = require('tako'),
  app = tako();

app.route('/').json({msg:'riak hosting for the rest of us', extra:'coming soon to a server near you!'});

app.httpServer.listen(80);
