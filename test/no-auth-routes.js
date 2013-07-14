var should = require('should'),
    request = require('request'),
    server_helper = require(__dirname + '/server_helper'),
    port = (process.env.TESTING_PORT || 3000),
    host = (process.env.TESTING_HOST || "http://localhost") + ':' + port;

var isGoodResponse = function(res){
  res.should.have.property('statusCode', 200);
}

describe('no authentication required', function(){
  before(function(done){
    if(!process.env.TESTING_HOST){
      server_helper(done);
    } else {
      done();
    }
  });
  it('should have a route a /', function(done){
    request(host, function(e,r,b){
      isGoodResponse(r);
      done();
    });
  });
});
