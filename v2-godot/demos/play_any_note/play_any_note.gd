extends Control


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var all_note_indexes: Label = (
	$HBoxContainer/VBoxContainer/HBoxContainer/AllNoteIndexes
)


const _all_note_indexes_ascending_list: Array[int] = [0, 2, 4]
const _note_length_seconds: float = 1
const _volume_mute_decibel = -60
const _volume_normal_decibel = 0


var queue_of_note_indexes_to_play: Array = []
var time_since_last_note_started: float = 0


func _ready():
	_refresh_all_note_indexes_text()


func _process(delta: float) -> void:
	time_since_last_note_started += delta

	if (time_since_last_note_started >= _note_length_seconds
		and not queue_of_note_indexes_to_play.is_empty()):
		_play_note_at_index(queue_of_note_indexes_to_play.pop_front())
		_refresh_all_note_indexes_text()


func _mute_streams():
	for stream_index in audio_stream_player.stream.get_stream_count():
		audio_stream_player.stream.set_sync_stream_volume(stream_index, _volume_mute_decibel)


#region Button pressed


func _on_button_c_4_pressed():
	_play_note_at_index(0)


func _on_button_d_4_pressed():
	_play_note_at_index(2)


func _on_button_e_4_pressed():
	_play_note_at_index(4)


func _on_button_play_all_sequentially_pressed():
	queue_of_note_indexes_to_play.append_array(_all_note_indexes_ascending_list)
	_refresh_all_note_indexes_text()

#endregion Button pressed


func _play_note_at_index(note_index: int) -> void:
	_mute_streams()
	audio_stream_player.stream.set_sync_stream_volume(
		note_index,
		_volume_normal_decibel % audio_stream_player.stream.get_stream_count()
	)
	audio_stream_player.play()
	time_since_last_note_started = 0


func _refresh_all_note_indexes_text():
	all_note_indexes.text = str(queue_of_note_indexes_to_play)
