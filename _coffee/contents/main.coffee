Gnav = require './gnav'
Contact = require './Contact'
setHieght = require './set-height'
Button = require './button/button'

$(->
	new Gnav($('#GNav'), $('.c-humberger'), $('#Main'))

	# CONTACT
	if $('.p-page-contact').length
		new Contact($('.p-form-set form'), $('.p-sec-contact .c-btn'))

	# CAREERS
	if $('.p-page-careers-entry').length
		new Contact($('.p-form-set form'), $('.p-sec-contact .c-btn'))

	# フッターロゴ
	if $('#Button').length
		new Button()

	# 高さ設定
	if $('.p-sec-projects__unit__pic').length
		new setHieght('.p-sec-projects__unit__pic img')
)