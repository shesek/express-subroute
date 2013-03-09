# express-subroute

Sub routes for express, with support for automatic OPTIONS response and 405
Method Not Allowed.

## Installation

Install via npm:

```bash
  $ npm install express-subroute
```

## Usage

```coffee
express = require 'express'
subroute = require 'subroute-express'

app = express()
subroute.install app # or subroute.install() to enable on all express apps

# or `subroute app, '/foo', ->` without `install()`ing
app.subroute '/foo', ->
  @get (req, res, next) -> # GET /foo
  @post somefn # POST /foo
  @get '/bar', somefn # GET /foo/bar

  @subroute '/baz', ->
    @use somefn # -> .use('/foo/baz', somefn)
    @get somefn # GET /foo/baz
    @put '/qux', somefn # PUT /foo/baz/qux
```

Works nicely with required modules:

```coffee
# main.coffee
app.subroute '/user', require './user'

# user.coffee
module.exports = ->
  @get (req, res) -> # GET /user
  @post '/:id', ... # POST /user/:id

```
