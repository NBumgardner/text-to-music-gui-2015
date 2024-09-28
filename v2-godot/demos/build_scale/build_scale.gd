# Demo of how to set a note via code to be played.
extends Control

const note_c_natural_4 = preload("res://audio/c-nat-4.wav")
const note_d_natural_4 = preload("res://audio/d-nat-4.wav")


func _ready():
	var scale_to_build = _build_stream_sequential()
	var notes_to_append_list = [note_c_natural_4, note_d_natural_4]

	for note_index in notes_to_append_list.size():
		scale_to_build.add_stream(note_index, notes_to_append_list[note_index])

	$AudioStreamPlayer.set_stream(scale_to_build)

	$VBoxContainer/ContainedNotes/LineEdit.text = 'Do Re'


func _build_stream_sequential() -> AudioStreamRandomizer:
	var scale_to_build = AudioStreamRandomizer.new()
	scale_to_build.playback_mode = scale_to_build.PLAYBACK_SEQUENTIAL
	return scale_to_build


func _on_play_button_pressed():
	if $AudioStreamPlayer.stream == null:
		print_debug('Nothing to play.')
		return

	print_debug('Playing audio.')
	$AudioStreamPlayer.play()


func _on_prepend_note_button_pressed():
	if $AudioStreamPlayer.stream != null:
		print_debug('Overwriting an existing audio stream.')
	else:
		print_debug('Setting audio.')

	$AudioStreamPlayer.stream.add_stream(-1, note_c_natural_4)


func _on_reset_button_pressed():
	if $AudioStreamPlayer.stream == null:
		print_debug('Nothing to reset.')
		return

	print_debug('Resetting audio.')
	$AudioStreamPlayer.set_stream(_build_stream_sequential())

	$VBoxContainer/ContainedNotes/LineEdit.text = ''
