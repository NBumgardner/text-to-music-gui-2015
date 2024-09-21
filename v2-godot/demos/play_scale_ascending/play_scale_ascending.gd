extends Control

var how_long_playing = 0
var maximum_note_count = 5
var note_count = -1
var note_length_in_seconds = 0.5

func _process(delta):
	_process_play_notes_sequentially(delta)


func _on_button_pressed():
	print_debug('Play first note.')
	note_count = 0
	$AudioStreamPlayer.play(0)


func _process_play_notes_sequentially(delta):
	if note_count == -1:
		return

	if how_long_playing < note_length_in_seconds:
		how_long_playing += delta
		return

	if note_count < maximum_note_count - 1:
		note_count += 1
		print_debug('Play next note at index ', note_count)
		how_long_playing = 0
		$AudioStreamPlayer.play()
		return

	print_debug('Finished playing ', note_count, ' notes.')
	note_count = -1
	how_long_playing = 0
	$AudioStreamPlayer.stop()
