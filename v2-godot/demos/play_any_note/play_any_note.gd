extends Control


const _volume_mute_decibel = -60
const _volume_normal_decibel = 0


func _mute_streams():
	for stream_index in $AudioStreamPlayer.stream.get_stream_count():
		$AudioStreamPlayer.stream.set_sync_stream_volume(stream_index, _volume_mute_decibel)


func _on_button_c_4_pressed():
	_play_note_at_index(0)


func _on_button_d_4_pressed():
	_play_note_at_index(2)


func _play_note_at_index(note_index: int) -> void:
	_mute_streams()
	$AudioStreamPlayer.stream.set_sync_stream_volume(
		note_index,
		_volume_normal_decibel % $AudioStreamPlayer.stream.get_stream_count()
	)
	$AudioStreamPlayer.play()
	
