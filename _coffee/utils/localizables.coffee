#
# Localizablesクラス
#

LOCALIZABLES = {
	'ja': {
		'This web page requires WebGL support.':'このページを表示するにはWebGLに対応したブラウザが必要です。',
		'The url is empty.':'URLが入力されていません',
		'The url and image file are both empty.':'URLおよび画像ファイルが入力されていません',
		'Invalid url.':'URLが正しくありません',
		'The url was not found.':'URLの画像にアクセスできませんでした',
		'No face was found.':'画像中に顔が検出されませんでした',
		'The face is not smiling. You can only upload a photo with smiling face(s).':'検出された顔が笑顔ではありません。笑顔の写真のみ登録できます。',
		'Unknown error.':'原因不明のエラーが発生しました',
		'Your page is ready.':'ページを生成しました。',
	}
}


class Localizables
	@lang: (navigator.browserLanguage || navigator.language || navigator.userLanguage).substr(0,2)

	@localize: (message) ->
		if LOCALIZABLES[@lang]?[message]? then message = LOCALIZABLES[@lang][message]
		return message

module.exports = Localizables