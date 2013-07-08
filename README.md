# express-subroute

Sub routes for express, with support for automatic OPTIONS response and 405
Method Not Allowed.

## Installation

Install via npm:

```bash
  $ npm install express-subroute
```

## Example
A tiny in-memory blog app. There's also a JavaScript version
at [USAGE.js](https://github.com/shesek/express-subroute/blob/master/USAGE.js).

```coffee
express  = require 'express'
subroute = require 'express-subroute'

express().configure ->
  subroute.install this # or require('express-subroute').install() to enable globally

  posts = []
  @param 'post', (req, res, next) ->
    if req.post = posts[req.params.post] then do next
    else res.send 404

  # or `subroute app, '/blog', ->` without `install()`ing
  @subroute '/blog', ->
    @get (req, res) -> res.end 'welcome!' 
    @get '/about', (req, res) -> res.end 'an example app' 
    
    @subroute '/post', ->
      @get (req, res) -> res.json posts 
      @post (req, res) -> posts.push req.body; res.send 204 
      @get '/:post', (req, res) -> res.json req.post
      @put '/:post', (req, res) -> posts[req.params.post]=req.body; res.send 204 
      @del '/:post', (req, res) -> delete posts[req.params.post]; res.send 204
 
      @subroute '/:post/comment', ->
        @get (req, res) -> res.json req.post.comments or [] 
        @post (req, res) -> (req.post.comments ||= []).push req.body; res.send 204

  # Adds handlers to the following methods/paths:
  # - GET|OPTIONS      /blog
  # - GET              /blog/about
  # - GET|POST|OPTIONS /blog/post
  # - GET|PUT|DELETE   /blog/post/:post
  # - GET|POST|OPTIONS /blog/post/:post/comment


  # you can also require() the function from another file
  @soubroute '/forum', require './forum'

# forum.coffee exports a function:
module.exports = ->
  @get (req, res) -> # ...
  @post (req, res) -> # ...
  # ...
```

If you don't setup an OPTIONS handler, one is automatically created for you
with all the methods used in the route. In addition, if none of the handlers
you register handle the request, an 405 Method not allowed response is sent.

For more info, see [the code](https://github.com/shesek/express-subroute/blob/master/index.coffee) (~30 lines)
and [the tests](https://github.com/shesek/express-subroute/blob/master/test.coffee).

Related:

- https://github.com/visionmedia/express/pull/1511
- https://github.com/visionmedia/express/issues/1499
- https://github.com/visionmedia/express/issues/1501

