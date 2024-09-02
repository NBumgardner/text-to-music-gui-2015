extends Control

const Convert = preload("../musical_translations/convert.gd")

signal set_play_vars(musical_scale: ScaleData, solfege_string: String)

var converter_methods = Convert.new()

@onready var input_control_to_translate: LineEdit = (
	$MarginContainer/VBoxContainer/RowUserInput/LineEdit
)

# Get output rows excluding the first row of user input.
@onready var play_var_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children().slice(1)
)

var _scale_in_solfege: Array[ScaleData] = []


func _ready():
	var incoming_scales_in_solfege: Array = (play_var_list.map(
		func(playVar: Node) -> ScaleData: return playVar.musical_scale
	))
	_scale_in_solfege.assign(incoming_scales_in_solfege)


func _on_button_pressed() -> void:
	# Get string to be translated.
	var raw_text: String = input_control_to_translate.text
	if raw_text == '': # Guardian.
		print_debug('NO INPUT FOUND. Please enter text for translation.')
		return

	print_debug(raw_text, 'will be translated into solfege.')
	
	var upper_cased_word_list: PackedStringArray = converter_methods.prepareStr(raw_text)

	# Strict typing of `Array[Array[int]]` is not supported.
	var numbers_translated_from_upper_cased_words_list = []
	# List of integer lists.
	# Values: 0 to 25.
	for upper_cased_word in upper_cased_word_list:
		# Type of `Array[int]` will be appended into an unsupported type of
		#  `Array[Array[int]]`.
		var numbers_in_valid_range_list = converter_methods.myStrToInt(
			upper_cased_word,
			26
		)
		numbers_translated_from_upper_cased_words_list.append(
			numbers_in_valid_range_list
		)
	print_debug(
		'Input Text in number format:',
		numbers_translated_from_upper_cased_words_list
	)

	# Replace other Entry fields.
	# Translates lists of numbers calculated from words.
	var scale_list_index: int = 0
	for play_var in play_var_list:
		var scaleUsed: ScaleData = _scale_in_solfege[scale_list_index]
		var result: String = converter_methods.iListsToSolfege(
			numbers_translated_from_upper_cased_words_list,
			scaleUsed.solfege_ascending_string.split(" ")
		)
		play_var.set_line_edit_text(result)
		set_play_vars.emit(result)
		scale_list_index += 1
	print_debug('Translation of ', scale_list_index, ' scales complete.')
