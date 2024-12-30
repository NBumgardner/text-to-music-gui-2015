# Visually implement the original Python GUI in Godot as a mimicking mock up.
extends Control


@export var _mock_scale_chromatic: ScaleData = preload(
	"res://data/scales/chromatic.tres"
)
@export var _scale_list: Array[ScaleData] = []


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
var _scale_in_solfege_list = []


func _get_scale_label_list():
	var grid_cells_list = $GridContainer.get_children()
	var grid_cells_labels_list = grid_cells_list.filter(
		func (child): return child is Label
	)
	return grid_cells_labels_list.slice(1)


func _ready():
	var scale_label_list = _get_scale_label_list()
	var scale_label_relative_row_index = 0
	for scale_label in scale_label_list:
		scale_label.text = _scale_list[
			scale_label_relative_row_index
		].label_name
		scale_label_relative_row_index += 1


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
		var scale_used = _scale_list[
			scale_line_edit_relative_row_index
		].solfege_ascending_string.split(
			' '
		)
		var scale_line_edit_updated_text = _converter_methods.iListsToSolfege(
			words_as_number_format_list,
			scale_used
		)
		print_debug(
			_debug_message_indentation,
			'Row index ',
			scale_line_edit_relative_row_index,
			' translated numbers ',
			words_as_number_format_list,
			' into solfege \'',
			scale_line_edit_updated_text,
			'\' mapped from ',
			scale_used.size(),
			' solfege symbols.'
		)
		scale_line_edit.text = scale_line_edit_updated_text
		scale_line_edit_relative_row_index += 1
	print_debug('Translation complete.')


func _set_scales_line_edits(translated_text):
	for scale_line_edit in scale_line_edit_list:
		scale_line_edit.text = translated_text
