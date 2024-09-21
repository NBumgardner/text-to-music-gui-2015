# Demo of how to set a note via code to be played.
extends Control

const note_c_natueral_4 = preload("res://audio/c-nat-4.wav")


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

	$AudioStreamPlayer.stream = note_c_natueral_4


func _on_reset_button_pressed():
	if $AudioStreamPlayer.stream == null:
		print_debug('Nothing to reset.')
		return

	print_debug('Resetting audio.')
	$AudioStreamPlayer.stream = null
