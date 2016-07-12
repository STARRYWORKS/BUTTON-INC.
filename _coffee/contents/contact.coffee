class Contact
	constructor: (@$form, @$trigger) ->
		@validator = @$form.parsley()
		@$trigger.on('click', @_onSubmit)
		return

	_onSubmit: (e) =>
		e.preventDefault()
		if @validator.validate()
			@$form.submit()
module.exports = Contact