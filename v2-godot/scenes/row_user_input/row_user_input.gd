extends HBoxContainer

signal request_to_translate(raw_text)

@onready var input_control_to_translate: LineEdit = (
	$LineEdit
)

func _on_button_pressed():
	# Get string to be translated.
	var raw_text: String = input_control_to_translate.text
	if raw_text == '': # Guardian.
		print_debug('NO INPUT FOUND. Please enter text for translation.')
		return

	print_debug('Requesting to translate: ', raw_text)
	request_to_translate.emit(raw_text)
