# Plays chromatic indexes from 0-9.
#
# Spaces and commas are ignored.
# Unknown characters play index 0.
class_name ScaledIndexPlayer extends Control


@export var note_length_seconds: float = 0.75


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var line_edit: LineEdit = $HBoxContainer/VBoxContainer/LineEdit
@onready var notes_to_play: Control = $HBoxContainer/VBoxContainer2/NotesToPlay
@onready var notes_to_play_header: Label = $HBoxContainer/VBoxContainer2/Header
@onready var play_button = $HBoxContainer/Button


@export var musical_scale: ScaleData = null


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
var _scale_in_solfege: Array[ScaleData] = []
var queue_of_note_indexes_to_play: Array = []
var time_since_last_note_started: float = 0


func _ready():
	if musical_scale != null:
		$HBoxContainer/ScaleName.text = musical_scale.label_name
		_note_index_modulo = musical_scale.length


func _process(delta: float) -> void:
	time_since_last_note_started += delta

	if ((time_since_last_note_started >= note_length_seconds)
		and not queue_of_note_indexes_to_play.is_empty()):
		_play_note_at_index(queue_of_note_indexes_to_play.pop_front())


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
	var notes_to_play_text_joined = _translated_notes_separator.join(
		notes_to_play_text_segments
	)
	notes_to_play.text = notes_to_play_text_joined


func _on_button_pressed() -> void:
	print_debug('line_edit.text:', line_edit.text)
	var translated_notes = line_edit.text.split(_translated_notes_separator)
	print_debug('line_edit.text split by separator:', translated_notes)

	for translated_note in translated_notes:
		if _ignored_character_ord_list.has(translated_note):
			continue

		var wrapped_around_note = int(translated_note) % _note_index_modulo

		print_debug(
			'Append wrapped around note ',
			translated_note,
			' as ',
			str(wrapped_around_note)
		)
		queue_of_note_indexes_to_play.append(
			wrapped_around_note
		)


func _on_line_edit_text_changed(new_text):
	_set_notes_to_play()


func _on_line_edit_text_submitted(new_text):
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
