var express = require('express')
  , subroute = require('express-subroute');


var app = express();
subroute.install(app); // or subroute.install() to enable on all express apps

// or `subroute(app, '/foo', function() {... })` without `install()`ing
app.subroute('/foo', function(r) {
  r.get(function(req, res, next){ }); // GET /foo
  r.post(somefn); // POST /foo
  r.get('/bar', somefn); // GET /foo/bar

  r.subroute('/baz', function(r){
    r.use(somefn); // -> .use('/foo/baz', somefn)
    r.get(somefn); // GET /foo/baz
    r.put('/qux', somefn); // PUT /foo/baz/qux
  });
});


// Works nicely with required modules:

// main.js
app.subroute('/user', require('./user'));

// user.js
module.exports = function (r) {
  r.get(function(req, res) { }); // GET /user
  r.post('/:id', somefn); // POST /user/:id
};

