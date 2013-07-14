var should = require('should'),
    request = require('request'),
    server_helper = require(__dirname + '/server_helper'),
    port = (process.env.TESTING_PORT || 3000),
    host = (process.env.TESTING_HOST || "http://localhost") + ':' + port,
    async = require('async');

describe('authentication required', function(){
  before(function(done){
    if(!process.env.TESTING_HOST){
      server_helper(done);
    } else {
      done();
    }
  });
  it('should fail on bad login', function(done){
    request.post(host + '/login', {json:true, body:{username:'wlaurance',password:'testing123'}}, function(e,r,b){
      r.should.have.property('statusCode', 200);
      done();
    });
  });
});
