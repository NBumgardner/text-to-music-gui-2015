extends Control


const _all_note_indexes_ascending_list: Array[int] = [0, 2, 4]
const _note_length_seconds: float = 1
const _volume_mute_decibel = -60
const _volume_normal_decibel = 0


var queue_of_note_indexes_to_play: Array = []
var time_since_last_note_started: float = 0


func _process(delta: float) -> void:
	time_since_last_note_started += delta

	if (time_since_last_note_started >= _note_length_seconds
		and not queue_of_note_indexes_to_play.is_empty()):
		_play_note_at_index(queue_of_note_indexes_to_play.pop_front())


func _mute_streams():
	for stream_index in $AudioStreamPlayer.stream.get_stream_count():
		$AudioStreamPlayer.stream.set_sync_stream_volume(stream_index, _volume_mute_decibel)


#region Button pressed

func _on_button_c_4_pressed():
	_play_note_at_index(0)


func _on_button_d_4_pressed():
	_play_note_at_index(2)


func _on_button_e_4_pressed():
	_play_note_at_index(4)


func _on_button_play_all_sequentially_pressed():
	queue_of_note_indexes_to_play.append_array(_all_note_indexes_ascending_list)


#endregion Button pressed


func _play_note_at_index(note_index: int) -> void:
	_mute_streams()
	$AudioStreamPlayer.stream.set_sync_stream_volume(
		note_index,
		_volume_normal_decibel % $AudioStreamPlayer.stream.get_stream_count()
	)
	$AudioStreamPlayer.play()
	time_since_last_note_started = 0
