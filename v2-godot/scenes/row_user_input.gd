extends HBoxContainer

const Convert = preload("res://musical_translations/convert.gd")

const _caseSensitive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	# Get string to be translated.
	var text = $LineEdit.text
	if text == '': # Guardian.
		print_debug('NO INPUT FOUND. Please enter text for translation.')
		return

	print_debug(text, 'will be translated into solfege.')
	
	var text2 = ""

	# Caps locked list of strings.
	if (not _caseSensitive):
		text2 = Convert.prepareStr(text)

	var text3 = []
	# List of integer lists.
	# Values: 0 to 25.
	for word in text2:
		var a = Convert.myStrToInt(word, 26)
		text3.append(a)
	print('Input Text in number format:', text3)

	# Replace other 4 Entry fields. Translates text3.
	var a = 0
	for e in self.playVars:
		var oldE = e.get()
		if oldE != '':
			print('   ', oldE, 'will be replaced.')
		var scaleUsed = self._scaleInSolfege[a]
		var result = Convert.iListsToSolfege(text3, scaleUsed)
		$LineEdit.text = result
		a += 1
	print('Translation complete.')
