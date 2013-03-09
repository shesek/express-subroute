methods = require 'methods'
 
curryThis = (fn) -> (a...) -> fn this, a...
isString = (o) -> (Object::toString.call o) is '[object String]'
 
path_methods = [ methods..., 'use', 'all' ]
 
wrap = (fn, method, path) -> (spath, a...) ->
  if isString spath then fn.call this, path+spath, a...
  else
    @_methods[method] = true if method not in ['use', 'all']
    fn.call this, path, spath, a...

subroute = (app, path, fn) ->
  # must be called on the original app
  app.use app.router unless app._usedRouter
  sapp = Object.create app, _methods: value: {}
  #for method in path_methods then do (method, fn=app[method]) ->
  #  app[method] = (a...) -> console.log 'called',method,a...;  fn.apply this, a
    
  sapp[method] = wrap app[method], method, path for method in path_methods

  fn.call sapp, sapp

  unless sapp._methods.options?
    sapp.options (req, res) -> res.header('Allow', allowed).end()
    allowed = (Object.keys sapp._methods).join(',').toUpperCase()
  sapp.all (req, res) -> res.send 405
 
subroute.install = (app = (require 'express').application) -> app.subroute = curryThis subroute
 
module.exports = subroute

