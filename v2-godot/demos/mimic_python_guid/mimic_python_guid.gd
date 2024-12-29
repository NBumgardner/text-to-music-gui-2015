# Visually implement the original Python GUI in Godot as a mimicking mock up.
extends Control


@onready var input_text_line_edit: LineEdit = $GridContainer/LineEdit
@onready var scale_line_edit_list = [
	$GridContainer/LineEdit2,
	$GridContainer/LineEdit3,
	$GridContainer/LineEdit4,
	$GridContainer/LineEdit5
]


const _convert = preload("../../musical_translations/convert.gd")


const _available_alphabet_letter_count = 26
const _translated_notes_separator = ' '


var _converter_methods = _convert.new()


func _on_translate_button_pressed():
	if input_text_line_edit.text == '':
		print_debug('NO INPUT FOUND. Please enter text for translation.')
		return

	print_debug(input_text_line_edit.text, ' will be translated into solfege.')

	var sanitized_word_list = _converter_methods.prepareStr(
		input_text_line_edit.text
	)

	var words_as_number_format_list = []
	for word in sanitized_word_list:
		words_as_number_format_list.append(
			_converter_methods.myStrToInt(word, _available_alphabet_letter_count)
		)
	print_debug('Input Text in number format: ', words_as_number_format_list)

	var sanitized_text = ''.join(
		sanitized_word_list
	)

	var translated_text = _translated_notes_separator.join(
		_converter_methods.myStrToInt(
			sanitized_text,
			_available_alphabet_letter_count
		)
	)

	_set_scales_line_edits(translated_text)


func _set_scales_line_edits(translated_text):
	for scale_line_edit in scale_line_edit_list:
		scale_line_edit.text = translated_text
