var sitemap = require('sitemap').createSitemap({
  hostname: process.env.HOST_NAME || 'http://www.riakriver.com',
  cacheTime: 600000,
  urls: [
    { url: '/'},
    { url: '/about'},
    { url: '/contact'},
    { url: '/login' }
  ]
});
module.exports = function(req, res){
  sitemap.toXML(function(xml){
    res.header('Content-Type', 'application/xml');
    res.send(xml);
  });
};
