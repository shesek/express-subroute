# express-subroute

Sub routes for express, with support for automatic OPTIONS response and 405
Method Not Allowed.

## Installation

Install via npm:

```bash
  $ npm install express-subroute
```

## Usage
(Written in CoffeeScript, JavaScript version
at [USAGE.js](https://github.com/shesek/express-subroute/blob/master/USAGE.js))

```coffee
express = require 'express'
subroute = require 'express-subroute'

app = express()
subroute.install app # or require('express-subroute').install() to enable on all express apps

# or `subroute app, '/foo', ->` without `install()`ing
app.subroute '/foo', ->
  @get (req, res) -> # GET /foo
  @post (req, res) -> # POST /foo
  @get '/bar', (req, res) -> # GET /foo/bar

  @subroute '/baz', ->
    @use ... # -> .use('/foo/baz', somefn)
    @get ... # GET /foo/baz
    @put '/qux', ... # PUT /foo/baz/qux

  # also passes an argument, if you prefer to avoid using `this`
  @subroute '/corge', (route) =>
    route.get ... # GET /foo/corge
```

Works nicely with required modules:

```coffee
# main.coffee
app.subroute '/user', require './user'

# user.coffee
module.exports = ->
  @get (req, res) -> # GET /user
  @post ... # POST /user
  @put '/:id', ... # PUT /user/:id

```

If you don't setup an OPTIONS handler, one is automatically created for you
with all the methods used in the route. In addition, if none of the handlers
you register handle the request, an 405 Method not allowed response is sent.

Related:

- https://github.com/visionmedia/express/pull/1511
- https://github.com/visionmedia/express/issues/1499
- https://github.com/visionmedia/express/issues/1501

