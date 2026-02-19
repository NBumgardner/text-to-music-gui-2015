## Plays solfege from Do to Ti.
##
## Spaces and commas are ignored.
## Unknown characters play index 0.
## Pressing the [i]Play[/i] [Button] will interrupt the currently playing notes.
class_name ScaledSolfegePlayer extends Control


## Signal called when the [i]Play[/i] [Button] is pressed.
signal play_button_pressed()


## Time in seconds to play each note.
@export var note_length_seconds: float = 0.75


## If [true], pressing the Play [Button] will queue up the new audio to play
##  after the scene's currently playing audio finishes.
@export var queue_play := false


## Musical scale to render a name and decide how to translate characters into
##  solfege.
@export var musical_scale: ScaleData = null


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var line_edit: LineEdit = $HBoxContainer/LineEdit
@onready var play_button = $HBoxContainer/Button


const _convert = preload("../../musical_translations/convert.gd")
const _ignored_character_ord_list = [
	32, # Single space
	44, # Comma
	_translated_notes_separator
]
const _translated_notes_separator = ' '
const _volume_mute_decibel = -60
const _volume_normal_decibel = 0


var _converter_methods = _convert.new()
var _note_index_modulo = 8
var queue_of_note_indexes_to_play: Array = []
var time_since_last_note_started: float = 0


func _ready():
	if musical_scale != null:
		$HBoxContainer/ScaleName.text = musical_scale.label_name
		_note_index_modulo = musical_scale.solfege_ascending_notes.size()


func _process(delta: float) -> void:
	time_since_last_note_started += delta

	if ((time_since_last_note_started >= note_length_seconds)
		and not queue_of_note_indexes_to_play.is_empty()):
		_play_note_at_index(queue_of_note_indexes_to_play.pop_front())


## Stop playing all audio notes of the scene.
func stop_notes():
	queue_of_note_indexes_to_play = []
	time_since_last_note_started = note_length_seconds
	audio_stream_player.stop()


func _mute_streams():
	for stream_index in audio_stream_player.stream.get_stream_count():
		audio_stream_player.stream.set_sync_stream_volume(stream_index, _volume_mute_decibel)


func _play_note_at_index(note_index: int) -> void:
	_mute_streams()
	audio_stream_player.stream.set_sync_stream_volume(
		note_index,
		_volume_normal_decibel % audio_stream_player.stream.get_stream_count()
	)
	audio_stream_player.play()
	time_since_last_note_started = 0


func _set_line_edit(text: String) -> void:
	line_edit.text = text
	_set_notes_to_play()


func _set_notes_to_play() -> void:
	var notes_to_play_text_segments = []
	var translated_notes = line_edit.text.split(_translated_notes_separator)
	for translated_note in translated_notes:
		if _ignored_character_ord_list.has(translated_note):
			continue

		var wrapped_around_note = int(translated_note) % _note_index_modulo

		notes_to_play_text_segments.append(
			wrapped_around_note
		)


func _on_button_pressed() -> void:
	play_button_pressed.emit()

	if not queue_play:
		stop_notes()

	print_debug('line_edit.text:', line_edit.text)
	var translated_notes = line_edit.text.split(_translated_notes_separator)
	print_debug('line_edit.text split by separator:', translated_notes)

	for translated_note in translated_notes:
		if (_ignored_character_ord_list.has(translated_note)
				or translated_note == ''):
			continue

		var translated_note_chromatic_index = _solfege_note_to_chromatic_index(
			translated_note
		)

		print_debug(
			'Append note ',
			translated_note,
			' as ',
			str(translated_note_chromatic_index)
		)
		queue_of_note_indexes_to_play.append(
			translated_note_chromatic_index
		)


func _on_line_edit_text_changed(_new_text):
	_set_notes_to_play()


func _on_line_edit_text_submitted(_new_text):
	_set_notes_to_play()
	$HBoxContainer/Button.pressed.emit()


func _on_row_user_input_request_to_translate(raw_text):
	var sanitized_text = ''.join(_converter_methods.prepareStr(raw_text))

	var translated_text = _translated_notes_separator.join(
		_converter_methods.myStrToInt(
			sanitized_text,
			26
		)
	)

	_set_line_edit(translated_text)

	print_debug('Parsing: ', raw_text)
	var upper_cased_word_list: PackedStringArray = converter_methods.prepareStr(
		raw_text
	)

	var numbers_translated_from_upper_cased_words_list = (
		_translate_words_list_into_numbers_list_list(upper_cased_word_list)
	)

	_set_other_entry_fields(numbers_translated_from_upper_cased_words_list)








const Convert = preload("../../musical_translations/convert.gd")

var converter_methods = Convert.new()


func set_line_edit_text(incoming_text: String) -> void:
	$HBoxContainer/LineEdit.text = incoming_text


func _solfege_note_to_chromatic_index(solfege_note: String) -> int:
	var solfege_strings = musical_scale.solfege_ascending_string.split(
		" ",
		false
	)
	var has_solfege_string_match = solfege_strings.has(solfege_note)

	if not has_solfege_string_match:
		return -1

	var solfege_string_match_index = solfege_strings.find(solfege_note)

	return musical_scale.solfege_ascending_notes[
		solfege_string_match_index
	].chromatic_index


# Replace other Entry fields.
# Translates lists of numbers, usually calculated from words, into solfege.
func _set_other_entry_fields(numbers_list_list: Array[Array]) -> void:
	var scale_list_index: int = 0

	if musical_scale == null:
		print_debug(
			'Error: Scaled solfege player is missing a musical_scale.'
		)
		return

	var result: String = converter_methods.iListsToSolfege(
		numbers_list_list,
		musical_scale.solfege_ascending_string.split(" ")
	)
	set_line_edit_text(result)

	print_debug('Translation of ', scale_list_index, ' scales complete.')

func _translate_words_list_into_numbers_list_list(word_list) -> Array[Array]:
	# Strict typing of `Array[Array[int]]` is not supported.
	var numbers_translated_from_word_list = []

	# List of integer lists.
	# Values: 0 to 25.
	for word in word_list:
		# Type of `Array[int]` will be appended into an unsupported type of
		#  `Array[Array[int]]`.
		var numbers_in_valid_range_list: Array = converter_methods.myStrToInt(
			word,
			26
		)
		numbers_translated_from_word_list.append(
			numbers_in_valid_range_list
		)

	print_debug(
		'Input Text in number format:',
		numbers_translated_from_word_list
	)

	return numbers_translated_from_word_list
