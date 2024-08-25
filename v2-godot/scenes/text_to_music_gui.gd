extends Control

const Convert = preload("../musical_translations/convert.gd")

signal set_play_vars(musical_scale: ScaleData, solfege_string: String)

var converter_methods = Convert.new()

@onready var inputControlToTranslate = $VBoxContainer/RowUserInput/LineEdit

# Get output rows excluding the first row of user input.
@onready var playVars: Array = $VBoxContainer.get_children().slice(1)

var _scaleInSolfege = [preload("../scales/major.tres")]

const _caseSensitive = false


func _on_button_pressed():
	# Get string to be translated.
	var text = inputControlToTranslate.text
	if text == '': # Guardian.
		print_debug('NO INPUT FOUND. Please enter text for translation.')
		return

	print_debug(text, 'will be translated into solfege.')
	
	var text2 = ""

	# Caps locked list of strings.
	if (not _caseSensitive):
		text2 = converter_methods.prepareStr(text)

	var text3 = []
	# List of integer lists.
	# Values: 0 to 25.
	for word in text2:
		var a = converter_methods.myStrToInt(word, 26)
		text3.append(a)
	print('Input Text in number format:', text3)

	# Replace other 4 Entry fields. Translates text3.
	var a = 0
	for e in playVars:
		var scaleUsed = _scaleInSolfege[a]
		var result = converter_methods.iListsToSolfege(
			text3,
			scaleUsed.solfege_ascending_string.split(" ")
		)
		e.set_line_edit_text(result)
		set_play_vars.emit(result)
		a += 1
	print('Translation complete.')
