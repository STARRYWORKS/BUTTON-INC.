gulp = require 'gulp'
watch = require 'gulp-watch'
browser = require 'browser-sync'
del = require 'del'
config = require '../config'

reload = browser.reload

# 
# images:del
# 
gulp.task 'images:del', (cb)->
	del [config.images.dist], cb

# 
# images:copy
# 
gulp.task 'images:copy',['images:del'], ->
	gulp.src config.images.src, {base: config.images.base}
		.pipe gulp.dest config.images.dist
		.pipe reload {stream:true}

# 
# images:watch
# 
gulp.task 'images:watch', ()->
	watch config.images.src, (event)->
		gulp.start 'images:copy'
