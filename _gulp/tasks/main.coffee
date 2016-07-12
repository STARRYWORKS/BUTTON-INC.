gulp = require 'gulp'
runSequence = require 'run-sequence'
spawn = require('child_process').spawn

#
# default
#
gulp.task 'default', ()->
	process = undefined
	restart = ->
		if typeof process != 'undefined' then process.kill()
		process = spawn('gulp',[
			'webpack:build'
			'plugin:build'
			'sass:build'
			'jade:build'
			'images:copy'
			'audiosprite:default:build'
			'audiosprite:secret:build'
			'server'
			'webpack:watch'
			'plugin:watch'
			'sass:watch'
			'jade:watch'
			'images:watch'
			'audiosprite:default:watch'
			'audiosprite:secret:watch'
		],{stdio: 'inherit'})
	gulp.watch ['gulpfile.coffee','./_gulp/**/*.coffee'],restart
	restart()

gulp.task 'release', ()->
	runSequence(
		['webpack:build:release']
		['plugin:build:release']
		['sass:build']
		['jade:build']
		['images:copy']
		['audiosprite:default:build']
		['audiosprite:secret:build']
		['del:release']
	)
