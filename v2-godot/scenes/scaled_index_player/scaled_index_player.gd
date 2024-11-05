# Plays chromatic indexes from 0-9.
#
# Spaces and commas are ignored.
# Unknown characters play index 0.
class_name ScaledIndexPlayer extends Control


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var line_edit: LineEdit = $HBoxContainer/LineEdit
@onready var play_button = $HBoxContainer/Button


@export var musical_scale: ScaleData = null


const _ignored_character_ord_list = [
	32, # Single space
	44 # Comma
]
const _note_length_seconds: float = 1
const _volume_mute_decibel = -60
const _volume_normal_decibel = 0


var _scale_in_solfege: Array[ScaleData] = []
var queue_of_note_indexes_to_play: Array = []
var time_since_last_note_started: float = 0


func _ready():
	if musical_scale != null:
		$HBoxContainer/ScaleName.text = musical_scale.label_name


func _process(delta: float) -> void:
	time_since_last_note_started += delta

	if (time_since_last_note_started >= _note_length_seconds
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


func _on_button_pressed() -> void:
	pass
	print_debug('line_edit.text:', line_edit.text)
	print_debug('line_edit.text.split():', line_edit.text.split())
	for character in line_edit.text:
		if _ignored_character_ord_list.has(character):
			continue

		queue_of_note_indexes_to_play.append(int(character))


func _on_line_edit_text_submitted(new_text):
	$HBoxContainer/Button.pressed.emit()
