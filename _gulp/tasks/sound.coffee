gulp = require 'gulp'
audiosprite = require 'gulp-audiosprite'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
watch = require 'gulp-watch'
config = require '../config'

# 
# audiosprite:default:build
# 
gulp.task 'audiosprite:default:build', ()->
	gulp.src config.sound_default.src
		.pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
		.pipe audiosprite config.sound_default.option
		.pipe gulp.dest config.sound_default.dist

# 
# audiosprite:default:watch
# 
gulp.task 'audiosprite:default:watch', ->
	watch [config.sound_default.src], (event)->
		gulp.start 'audiosprite:defaul:build'


# 
# audiosprite:secret:build
# 
gulp.task 'audiosprite:secret:build', ()->
	gulp.src config.sound_secret.src
		.pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
		.pipe audiosprite config.sound_secret.option
		.pipe gulp.dest config.sound_secret.dist

# 
# audiosprite:secret:watch
# 
gulp.task 'audiosprite:secret:watch', ->
	watch [config.sound_secret.src], (event)->
		gulp.start 'audiosprite:secret:build'
