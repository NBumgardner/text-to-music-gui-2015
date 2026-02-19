extends HBoxContainer

## Signal called with the contents of the [LineEdit] when the [i]Translate[/i]
##  [Button] is pressed.
## [br][br]
## Also called when pressing [i]Enter[/i] on a keyboard while focused on the
##  [LineEdit].
signal request_to_translate(raw_text)


@onready var input_control_to_translate: LineEdit = $LineEdit


## Get [LineEdit] text.
func get_line_edit_text():
	return input_control_to_translate.text


## Emit signal [request_to_translate] containing the [LineEdit] text to
##  translate.
func request_to_translate_line_edit():
	# Get string to be translated.
	var raw_text: String = get_line_edit_text()
	if raw_text == '': # Guardian.
		print_debug('NO INPUT FOUND. Please enter text for translation.')
		return

	print_debug('Requesting to translate: ', raw_text)
	request_to_translate.emit(raw_text)


## Set [LineEdit] text.
func set_line_edit_text(text):
	input_control_to_translate.set_text(text)


func _on_button_pressed():
	request_to_translate_line_edit()


func _on_line_edit_text_submitted(_new_text):
	$Button.pressed.emit()
