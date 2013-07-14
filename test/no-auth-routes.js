var should = require('should'),
    request = require('request'),
    server_helper = require(__dirname + '/server_helper'),
    port = (process.env.TESTING_PORT || 3000),
    host = (process.env.TESTING_HOST || "http://localhost") + ':' + port,
    async = require('async');

describe('no authentication required', function(){
  before(function(done){
    if(!process.env.TESTING_HOST){
      server_helper(done);
    } else {
      done();
    }
  });
  it('should have a routes', function(done){
    var iterator = function(route, callback){
      request(host + route, function(e,r,b){
        r.should.have.property('statusCode', 200);
        callback();
      });
    }
    async.each(['/', '/about', '/contact', '/login'], iterator, done);
  });
});
