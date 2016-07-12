# 本番時の設定
# uglify : true
# devtool : 項目削除
path = require("path")
current = process.cwd()

relativePath = "./"
dist = "dist/"

# エントリーポイント
entry = {
	"main"															: "./_coffee/main.coffee"
	"mock/01-paper_position/main"				: "./_coffee/_mock/01-paper_position/main.coffee"
	"mock/02-shape_tween/main"					: "./_coffee/_mock/02-shape_tween/main.coffee"
	"mock/03-cos_sin/main"							: "./_coffee/_mock/03-cos_sin/main.coffee"
	"mock/04-morphable_path/main"				: "./_coffee/_mock/04-morphable_path/main.coffee"
	"mock/05-fluidable_path/main"				: "./_coffee/_mock/05-fluidable_path/main.coffee"
	"mock/06-paper_position_check/main"	: "./_coffee/_mock/06-paper_position_check/main.coffee"
	"mock/07-audio_sprite/main"					: "./_coffee/_mock/07-audio_sprite/main.coffee"
	"mock/08-svg_morph/main"						: "./_coffee/_mock/08-svg_morph/main.coffee"
	"mock/09-custom_stroke/main"				: "./_coffee/_mock/09-custom_stroke/main.coffee"
	"contents"													: "./_coffee/contents/main.coffee"
}

module.exports =
	server:
		dir: "#{relativePath}#{dist}"
		watch: [
			"#{dist}js/*.js"
			"#{dist}css/*.css"
			"#{dist}**/*.html"
		]
	js:
		dist: "#{relativePath}#{dist}js/"
		uglify: false
		releasePlugin: [
			"_lib/10_jquery.min.js"
			"_lib/12_velocity.min.js"
			"_lib/13_tween.js"
			"_lib/14_TweenMax.min.js"
			"_lib/15_cheet.min.js"
			"_lib/30_paper-core.min.js"
			"_lib/50_soundjs-0.6.2.min.js"
			"_lib/98_parsley.min.js"
			"_lib/99_ua.js"
		]
	webpack:
		entry: entry
		output:
			filename: "[name].js"
		devtool: "inline-source-map"
		resolve:
			extensions: ['','.coffee','.js']
			# requireのパス省略
			alias:
				"config"					: path.join(current, '_coffee/config.coffee')
				"scene-base"			: path.join(current, "_coffee/scene/scene-base.coffee")
				"extension"				: path.join(current, "_coffee/utils/extension.coffee")
				"sound-manager"		: path.join(current, "_coffee/utils/sound-manager.coffee")
				"utils"						: path.join(current, "_coffee/utils/utils.coffee")
				"event"						: path.join(current, "_coffee/utils/event.coffee")
				"touch"						: path.join(current, "_coffee/utils/touch.coffee")
				"btn"							: path.join(current, "_coffee/format/btn.coffee")
				"base"						: path.join(current, "_coffee/format/base.coffee")
				"logo-type"				: path.join(current, "_coffee/format/logo-type.coffee")
				"morphable-path"	: path.join(current, "_coffee/format/morphable-path.coffee")
				"fluidable-path"	: path.join(current, "_coffee/format/fluidable-path.coffee")
				"custom-stroke"		: path.join(current, "_coffee/format/custom-stroke.coffee")
				"paper-stage"			: path.join(current, "_coffee/stage/paper-stage.coffee")
		module:
			loaders: [
				{test: /\.coffee$/, loader: "coffee"}
			]
	jade:
		src: ["./_html/**/*.jade"]
		dist: "dist"
		option:
			pretty: true
	sass:
		src: ['_scss/**/*.scss']
		dist: "#{relativePath}#{dist}css/"
	images:
		base: "_html/images"
		src: "./_html/images/**"
		dist: "./dist/images/"
	sound_default:
		src: "_sounds/*"
		dist: "#{dist}sound/"
		option:
			output: "default"
			path: "/sound"
			format: "createjs"
			export: "mp3"
			bitrate: 100
			# samplerate: 22050
	sound_secret:
		src: "_sounds/secret/*"
		dist: "#{dist}sound/"
		option:
			output: "secret"
			path: "/sound"
			format: "createjs"
			export: "mp3"
			bitrate: 100
			# samplerate: 22050
	del: [
		"./dist/_list.html"
		"./dist/_include/"
		"./dist/mock/"
		"./dist/js/mock/"
		"./dist/css/mock/"
		"./dist/sound/secret/"
	]
