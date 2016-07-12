gulp = require 'gulp'
browser = require 'browser-sync'
config = require '../config'

reload = browser.reload

# WebServer Task
gulp.task 'server', ()->
	browser(
		server :
			baseDir: config.server.dir
	)

	# ブラウザリロード
	gulp.watch(config.server.watch).on 'change' , reload