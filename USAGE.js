var express  = require('express')
  , subroute = require('express-subroute')
  , app = express();


subroute.install(app); // or require('express-subroute').install() to enable globally

var posts = [];
app.param('post', function(req, res, next) {
  if (req.post = posts[req.params.post]) {
    next();
  } else {
    res.send(404);
  }
});

// or `subroute(app, '/blog', function() { ... })` without `install()`ing
app.subroute('/blog', function(app) {
  // the `app` _argument_ is bound to the '/blog' path, so that everything registered with it
  // is automatically under '/blog'. the same argument is also passed as the `this` context,
  // which is used in CoffeeScript with the `@` syntactic sugar, but not much useful in JavaScript.
  app.get(function(req, res) {
    res.end('welcome!');
  });
  app.get('/about', function(req, res) {
    res.end('an example app');
  });

  app.subroute('/post', function(app) {
    app.get(function(req, res) {
      res.json(posts);
    });
    app.post(function(req, res) {
      posts.push(req.body);
      res.send(200);
    });
    app.get('/:post', function(req, res, next) {
      res.json(req.post);
    });

    app.subroute('/:post/comment', function(app) {
      app.get(function(req, res) {
        res.json(req.post.comments || []);
      });
      app.post(function(req, res) {
        var post = req.post;
        (post.comments || (post.comments = [])).push(req.body);
        res.send(200);
      });
    });
  });
});

// or by require()ing another file
app.soubroute('/forum', require('./forum'));


// forum.coffee exports a function:
module.exports = function(app) {
  app.get(function(req, res) { /* ... */});
  app.post(function(req, res) { /* ... */ });
};

// Note: for something like a blog or a forum, you should probably create sub-apps and
//       mount them to the main app, rather than using subroutes. its more suitable for
//       smaller things. I'm just using this as an example.
