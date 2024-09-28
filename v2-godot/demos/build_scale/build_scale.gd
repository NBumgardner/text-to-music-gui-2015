# Demo of how to set a note via code to be played.
extends Control

const chromatic_index_to_streams = preload(
	"res://data/chromatic_index_to_pitch/c4_compressed.tres"
)
const note_c_natural_4 = preload("res://audio/c-nat-4.wav")
const scale_pentatonic = preload("res://data/scales/pentatonic.tres")


func _ready():
	var scale_to_build = _build_stream_sequential()
	var notes_to_append_list = []
	notes_to_append_list = scale_pentatonic.solfege_ascending_notes.map(
		func(solfegeNote: SolfegeNoteData):
			return chromatic_index_to_streams.pitch_list[
				solfegeNote.chromatic_index
			]
	)

	for note_index in notes_to_append_list.size():
		scale_to_build.add_stream(note_index, notes_to_append_list[note_index])

	$AudioStreamPlayer.set_stream(scale_to_build)

	$VBoxContainer/ContainedNotes/LineEdit.text = (
		scale_pentatonic.solfege_ascending_string
	)


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
