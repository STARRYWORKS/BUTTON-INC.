gulp = require 'gulp'
jade = require 'gulp-jade'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
browser = require 'browser-sync'
watch = require 'gulp-watch'
config = require '../config'
reload = browser.reload

# 
# jade:build
# 
gulp.task "jade:build", ->
	gulp.src config.jade.src
		.pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
		.pipe jade config.jade.option
		.pipe gulp.dest config.jade.dist
		.pipe reload({stream:true})

# 
# jade:watch
# 
gulp.task 'jade:watch', ->
	watch config.jade.src, (event)->
		gulp.start "jade:build"

