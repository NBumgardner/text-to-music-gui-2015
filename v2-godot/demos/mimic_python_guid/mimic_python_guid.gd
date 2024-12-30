# Visually implement the original Python GUI in Godot as a mimicking mock up.
extends Control


@export var _mock_scale_chromatic: ScaleData = preload(
	"res://data/scales/chromatic.tres"
)
@export var _scale_list: Array[ScaleData] = []


@onready var input_text_line_edit: LineEdit = $GridContainer/LineEdit


const _convert = preload("../../musical_translations/convert.gd")


const _available_alphabet_letter_count = 26
const _debug_message_indentation = '    '
const _translated_notes_separator = ' '


var _converter_methods = _convert.new()
var _scale_line_edit_list = []


func _get_scale_button_list() -> Array:
	var grid_cells_list = $GridContainer.get_children()
	var grid_cells_line_edit_list = grid_cells_list.filter(
		func (child): return child is Button
	)
	return grid_cells_line_edit_list.slice(1)


func _get_scale_line_edit_list() -> Array:
	var grid_cells_list = $GridContainer.get_children()
	var grid_cells_line_edit_list = grid_cells_list.filter(
		func (child): return child is LineEdit
	)
	return grid_cells_line_edit_list.slice(1)


func _get_scale_label_list() -> Array:
	var grid_cells_list = $GridContainer.get_children()
	var grid_cells_label_list = grid_cells_list.filter(
		func (child): return child is Label
	)
	return grid_cells_label_list.slice(1)


func _ready() -> void:
	_initialize_scale_rows(_scale_list)


func _initialize_scale_rows(scale_list: Array[ScaleData]) -> void:
	_scale_line_edit_list = _get_scale_line_edit_list()

	var scale_button_list = _get_scale_button_list()
	var scale_label_list = _get_scale_label_list()
	
	var scale_button_list_size = scale_button_list.size()
	var scale_label_list_size = scale_label_list.size()
	var scale_list_size = scale_list.size()

	if (
		scale_list_size != scale_button_list_size
		or scale_list_size != scale_label_list_size
	):
		print_debug(
			'Warning: Scale list of ',
			scale_list_size,
			' rows mismatches with ',
			scale_button_list_size,
			' scale buttons and ',
			scale_label_list.size(),
			' scale labels.'
		)
		assert(
			scale_list_size == scale_button_list_size
				and scale_list_size == scale_label_list_size,
			'Warning: Length of scale list does not match the length of '
				+ 'scale buttons and labels.'
		)

	for scale_relative_row_index in range(scale_list_size):
		scale_button_list[scale_relative_row_index].pressed.connect(
			_on_play_scale.bind(scale_relative_row_index)
		)

		scale_label_list[scale_relative_row_index].text = scale_list[
			scale_relative_row_index
		].label_name
		scale_relative_row_index += 1


func _on_play_scale(scale_relative_row_index: int) -> void:
	print_debug(
		_get_scale_label_list()[scale_relative_row_index].text,
		' scale button was pressed.'
	)


func _on_translate_button_pressed() -> void:
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

	var scale_relative_row_index = 0
	for scale_line_edit in _scale_line_edit_list:
		if scale_line_edit.text != '':
			print(
				_debug_message_indentation,
				scale_line_edit.text,
				' will be replaced.'
			)
		var scale_used = _scale_list[
			scale_relative_row_index
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
			scale_relative_row_index,
			' translated numbers ',
			words_as_number_format_list,
			' into solfege \'',
			scale_line_edit_updated_text,
			'\' mapped from ',
			scale_used.size(),
			' solfege symbols.'
		)
		scale_line_edit.text = scale_line_edit_updated_text
		scale_relative_row_index += 1
	print_debug('Translation complete.')


func _set_scales_line_edits(translated_text) -> void:
	for scale_line_edit in _scale_line_edit_list:
		scale_line_edit.text = translated_text
