methods = require 'methods'
 
curryThis = (fn) -> (a...) -> fn this, a...
isString = (o) -> (Object::toString.call o) is '[object String]'
 
path_methods = [ methods..., 'use', 'all' ]
 
current_path = ''

wrap = (fn, method) -> (spath, a...) ->
  if isString spath then fn.call this, current_path+spath, a...
  else
    @_methods[method] = true unless method in ['use', 'all']
    fn.call this, current_path, spath, a...

subroute = (app, path, fn) ->
  previous_path = current_path
  current_path += path
  dp fn
  current_path = previous_path
 
subroute.install = (app = (require 'express').application) ->
  app.subroute = curryThis subroute
  app[method] = wrap fn, app[method] for methid in path_methods
  app
 
module.exports = subroute

