var express = require('express')
  , subroute = require('express-subroute');
  , app = express();

subroute.install(app); // or require('express-subroute').install() to enable on all express apps

// or `subroute(app, '/foo', function() {... })` without `install()`ing
app.subroute('/foo', function() {
  this.get(function(req, res) {}); // GET /foo
  this.post(function(req, res) {}); // POST /foo
  this.get('/bar', function(req, res) {}); // GET /foo/bar

  this.subroute('/baz', function() {
    this.use(...); // -> .use('/foo/baz', ...)
    this.get(...); // -> GET /foo/baz
    this.put('/qux', ...); // PUT /foo/baz/qux
  });

  // also passes an argument, if you prefer to avoid using `this`
  this.subroute('/corge', function(route) {
    route.get(...); // GET /foo/corge
  });
});



// Works nicely with required modules:

// main.js
app.subroute('/user', require('./user'));

// user.js
module.exports = function (r) {
  this.get(...); // GET /user
  this.post(...); // POST /user
  this.put('/:id', ...); // PUT /:id
};

