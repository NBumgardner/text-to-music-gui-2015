# Visually implement the original Python GUI in Godot as a mimicking mock up.
extends Control


@export var _mock_scale_chromatic: ScaleData = preload(
	"res://data/scales/chromatic.tres"
)


@onready var input_text_line_edit: LineEdit = $GridContainer/LineEdit
@onready var scale_line_edit_list = [
	$GridContainer/LineEdit2,
	$GridContainer/LineEdit3,
	$GridContainer/LineEdit4,
	$GridContainer/LineEdit5
]


const _convert = preload("../../musical_translations/convert.gd")


const _available_alphabet_letter_count = 26
const _debug_message_indentation = '    '
const _translated_notes_separator = ' '


var _converter_methods = _convert.new()
var _mock_scale_used_chromatic = (
	_mock_scale_chromatic.solfege_ascending_string.split(
		' '
	)
)


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
			_converter_methods.myStrToInt(
				word,
				_available_alphabet_letter_count
			)
		)
	print_debug('Input Text in number format: ', words_as_number_format_list)

	var scale_line_edit_relative_row_index = 0
	for scale_line_edit in scale_line_edit_list:
		if scale_line_edit.text != '':
			print(
				_debug_message_indentation,
				scale_line_edit.text,
				' will be replaced.'
			)
		var scale_used = _mock_scale_used_chromatic
		var scale_line_edit_updated_text = _converter_methods.iListsToSolfege(
			words_as_number_format_list,
			scale_used
		)
		print_debug(
			'DEBUG01: row ',
			scale_line_edit_relative_row_index,
			', ',
			'words_as_number_format_list: ',
			words_as_number_format_list,
			', using solfege of: ',
			scale_used,
			' translated into scale_line_edit_updated_text: ',
			scale_line_edit_updated_text,
			'.'
		)
		scale_line_edit.text = scale_line_edit_updated_text
		scale_line_edit_relative_row_index += 1
	print_debug('Translation complete.')


func _set_scales_line_edits(translated_text):
	for scale_line_edit in scale_line_edit_list:
		scale_line_edit.text = translated_text
