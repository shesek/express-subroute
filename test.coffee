express   = require 'express'
request   = require 'supertest'
assert    = require 'assert'
subroute  = require './index'

using = (ctx, fn) -> fn.call ctx; ctx

describe 'subroute', ->
  describe '.install', ->
    it 'adds the subroute method to an app', ->
      subroute.install app = express()
      assert app.subroute?

    it 'installs globally when no target app is provided', ->
      subroute.install()
      assert express().subroute?
  describe 'using subroutes', ->
    it 'binds the route methods to use a default path when its omitted', (done) ->
      app = using express(), ->
        @subroute '/foo', ->
          @post (req, res) -> res.end 'POST /foo'
      request(app).post('/foo').expect('POST /foo', done)

    it 'uses the default path as a prefix when its specified', (done) ->
      app = using express(), ->
        @subroute '/foo', ->
          @put '/bar', (req, res) -> res.end 'PUT /foo/bar'
      request(app).put('/foo/bar').expect('PUT /foo/bar', done)

    it 'works with multiple and nested subroutes', (done) ->
      app = using express(), ->
        @subroute '/foo', ->
          @post (req, res) -> res.end 'POST /foo'
          @put '/bar', (req, res) -> res.end 'PUT /foo/bar'

          @subroute '/qux', ->
            @get (req, res) -> res.end 'GET /foo/qux'
            @lock '/corge', (req, res) -> res.end 'LOCK /foo/qux/corge'

      done = do (done, waiting=4) -> (err) -> if err? then done err else if not --waiting then do done

      request(app).post('/foo').expect('POST /foo', done)
      request(app).put('/foo/bar').expect('PUT /foo/bar', done)
      request(app).get('/foo/qux').expect('GET /foo/qux', done)
      request(app).lock('/foo/qux/corge').expect('LOCK /foo/qux/corge', done)

    it 'also passes the wrapped app as an argument', ->
      using express(), -> @subroute '/foo', (arg) -> assert this is arg

  describe 'OPTIONS handler', ->
    it 'automatically respondes to OPTIONS with the accepted methods', (done) ->
      app = using express(), ->
        @subroute '/foo', ->
          @get ->
          @post ->
          @put ->
      request(app).options('/foo').expect('Allow', 'GET,POST,PUT,OPTIONS', done)

    it 'doesnt add an handler if one already exists', (done) ->
      app = using express(),  ->
        @subroute '/foo', ->
          @options (req, res) -> res.header('Allow', 'FOO,BAR').end()
      request(app).options('/foo').expect('Allow', 'FOO,BAR', done)

  describe '405 Method Not Allowed', (done) ->
    it 'returns 405 Method Not Allowed for unhandled requests', (done) ->
      app = using express(), -> @subroute '/bar', -> @get (req, res) -> res.send 200
      request(app).put('/bar').expect(405, done)

