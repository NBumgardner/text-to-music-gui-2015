## Plays solfege from Do to Ti.
##
## Spaces and commas are ignored.
## Unknown characters play index 0.
## Pressing the [i]Play[/i] [Button] will interrupt the currently playing notes.
class_name ScaledSolfegePlayer extends Control


## Signal called when the [i]Play[/i] [Button] is pressed.
signal play_button_pressed()


## Every pitch scale to decide how to playback solfege.
## Missing symbols are skipped during playback.
@export var every_pitch_scale_for_playback: ScaleData = preload(
	"res://data/scales/chromatic_with_all_solfege.tres"
)


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
@onready var sfx_mouse_hover = $SfxMouseHover


const IGNORED_CHARACTER_ORD_LIST = [
	32, # Single space
	44, # Comma
	TRANSLATED_NOTES_SEPARATOR
]
const TRANSLATED_NOTES_SEPARATOR = ' '
const VOLUME_MUTE_DECIBEL = -60
const VOLUME_NORMAL_DECIBEL = 0


var _converter_methods: Convert = Convert.new()


## Number of unique pitches per octave of the [musical_scale] input.
## [br][br]
## Used when translating incoming text into solfege.
## Not used during audio playback.
var _note_index_modulo = 8


var queue_of_note_indexes_to_play: Array = []
var time_since_last_note_started: float = 0


func _ready():
	if musical_scale != null:
		$HBoxContainer/MarginContainer/ScaleName.text = musical_scale.label_name
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
		audio_stream_player.stream.set_sync_stream_volume(
			stream_index,
			VOLUME_MUTE_DECIBEL
		)


## Start playing a note at the given index of the
##  [every_pitch_scale_for_playback].
func _play_note_at_index(note_index: int) -> void:
	_mute_streams()

	if note_index == -1:
		# Play silence for unrecognized solfege including [code](rest)[/code].
		time_since_last_note_started = 0
		return

	audio_stream_player.stream.set_sync_stream_volume(
		note_index,
		VOLUME_NORMAL_DECIBEL % audio_stream_player.stream.get_stream_count()
	)
	audio_stream_player.play()

	time_since_last_note_started = 0


func _set_line_edit(text: String) -> void:
	line_edit.text = text
	_set_notes_to_play()


func _set_notes_to_play() -> void:
	var notes_to_play_text_segments = []
	var translated_notes = line_edit.text.split(TRANSLATED_NOTES_SEPARATOR)
	for translated_note in translated_notes:
		if IGNORED_CHARACTER_ORD_LIST.has(translated_note):
			continue

		var wrapped_around_note = int(translated_note) % _note_index_modulo

		notes_to_play_text_segments.append(
			wrapped_around_note
		)


func _on_button_play_pressed() -> void:
	play_button_pressed.emit()

	if not queue_play:
		stop_notes()

	print_debug('line_edit.text:', line_edit.text)
	var translated_notes = line_edit.text.split(TRANSLATED_NOTES_SEPARATOR)
	print_debug('line_edit.text split by separator:', translated_notes)

	for translated_note in translated_notes:
		if (IGNORED_CHARACTER_ORD_LIST.has(translated_note)
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


## Usually called once for each [ScaledSolfegePlayer] when the [i]Translate[/i]
##  [Button] of a [RowUserInput] is clicked.
func _on_row_user_input_request_to_translate(raw_text):
	var sanitized_text = ''.join(
		_converter_methods.sanitizeStringIntoUppercaseWordList(raw_text)
	)

	var translated_text = TRANSLATED_NOTES_SEPARATOR.join(
		_converter_methods.myStrToInt(
			sanitized_text,
			26
		)
	)

	_set_line_edit(translated_text)

	print_debug('Parsing: ', raw_text)
	var uppercase_word_list: PackedStringArray = (
		_converter_methods.sanitizeStringIntoUppercaseWordList(
			raw_text
		)
	)

	var numbers_translated_from_upper_cased_words_list = (
		_translate_words_list_into_numbers_list_list(uppercase_word_list)
	)

	_set_other_entry_fields(numbers_translated_from_upper_cased_words_list)


## Set [LineEdit] text.
func set_line_edit_text(incoming_text):
	line_edit.text = incoming_text


func _solfege_note_to_chromatic_index(solfege_note: String) -> int:
	var solfege_strings = (
		every_pitch_scale_for_playback.solfege_ascending_string.split(
			TRANSLATED_NOTES_SEPARATOR,
			false
		)
	)
	var has_solfege_string_match = solfege_strings.has(solfege_note)

	if not has_solfege_string_match:
		return -1

	var solfege_string_match_index = solfege_strings.find(solfege_note)

	return every_pitch_scale_for_playback.solfege_ascending_notes[
		solfege_string_match_index
	].chromatic_index


## Replace other Entry fields.
## Translates lists of numbers, usually calculated from words, into solfege.
func _set_other_entry_fields(numbers_list_list) -> void:
	var scale_list_index: int = 0

	if musical_scale == null:
		print_debug(
			'Error: Scaled solfege player is missing a musical_scale.'
		)
		return

	var result: String = _converter_methods.iListsToSolfege(
		numbers_list_list,
		musical_scale.solfege_ascending_string.split(TRANSLATED_NOTES_SEPARATOR)
	)
	set_line_edit_text(result)

	print_debug('Translation of ', scale_list_index, ' scales complete.')

func _translate_words_list_into_numbers_list_list(word_list):
	# Strict typing of `Array[Array[int]]` is not supported.
	var numbers_translated_from_word_list = []

	# List of integer lists.
	# Values: 0 to 25.
	for word in word_list:
		# Type of `Array[int]` will be appended into an unsupported type of
		#  `Array[Array[int]]`.
		var numbers_in_valid_range_list = _converter_methods.myStrToInt(
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


func _on_button_mouse_entered():
	sfx_mouse_hover.play()
