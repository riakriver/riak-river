async = require 'async'
module.exports = (app, glog)->
  app.get '/blog', (req, res)->
    posts = []
    glog.list()
    .on('data', (post) ->
      posts.push post)
    .on 'end', ->
      iterator = (post, cb) ->
        buffer = ""
        glog.read(post.file)
        .on 'data', (d)->
          buffer += d.toString()
        .on 'end', ->
          post.content = buffer
          cb()
      async.each posts, iterator, ->
        res.render 'blog', posts: posts
