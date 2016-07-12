gulp = require 'gulp'
plumber = require 'gulp-plumber'
webpack = require 'gulp-webpack'
coffee = require 'coffee-loader'
notify = require 'gulp-notify'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'
gulpif = require 'gulp-if'

config = require '../config'

# 
# webpack:build
# 
gulp.task 'webpack:build', ->
	gulp.src ""
		.pipe webpack config.webpack
		.pipe gulpif config.js.uglify, uglify()
		.pipe gulp.dest config.js.dist

# 
# webpack:build:release
# 
gulp.task 'webpack:build:release', ->
	gulp.src ""
		.pipe webpack config.webpack
		.pipe uglify()
		.pipe gulp.dest config.js.dist

# 
# webpack:watch
# 
gulp.task 'webpack:watch', ->
	watch ['_coffee/**/*.coffee'], (event)->
		gulp.start 'webpack:build'

# 
# plugin:build
# 
gulp.task 'plugin:build', ()->
	gulp.src '_lib/*.js'
	.pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
	.pipe concat 'plugin.js'
	.pipe gulp.dest config.js.dist

# 
# plugin:build:release
# 
gulp.task 'plugin:build:release', ()->
	gulp.src config.js.releasePlugin
	.pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
	.pipe concat 'plugin.js'
	.pipe gulp.dest config.js.dist

# 
# plugin:watch
# 
gulp.task 'plugin:watch', ->
	watch ['_lib/*.js'], (event)->
		gulp.start 'plugin:build'
