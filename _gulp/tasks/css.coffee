gulp = require 'gulp'
autoprefixer = require 'gulp-autoprefixer'
plumber = require 'gulp-plumber'
browser = require 'browser-sync'
notify = require 'gulp-notify'
watch = require 'gulp-watch'
sass = require 'gulp-sass'
config = require '../config'

reload = browser.reload

# 
# sass:build
# 各sass #ToDo - 要件等
# 
gulp.task 'sass:build', ()->
	gulp.src config.sass.src
		.pipe sass({outputStyle: 'expanded'}).on('error', sass.logError)
		.pipe autoprefixer(browsers: ['last 4 versions'])
		.pipe gulp.dest config.sass.dist
		.pipe reload({stream:true})

# 
# sass:watch
# 
gulp.task 'sass:watch', ->
	watch config.sass.src, (event)->
		gulp.start 'sass:build'

