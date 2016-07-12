gulp = require 'gulp'
del = require 'del'
config = require '../config'

# 
# images:del
# 
gulp.task 'del:release', (cb)->
	del config.del, cb
