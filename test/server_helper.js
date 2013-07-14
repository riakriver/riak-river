var started = false;
module.exports = function(done){
  if (!started) {
    var server = require(__dirname + '/../app');
    server(function(){
      started = true;
      done();
    });
  } else {
    done();
  }
}
