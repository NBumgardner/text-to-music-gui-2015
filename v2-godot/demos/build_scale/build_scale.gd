# Demo of how to set a note via code to be played.
extends Control

const chromatic_index_to_streams = preload(
	"res://data/chromatic_index_to_pitch/c4_compressed.tres"
)
const note_c_natural_4 = preload("res://audio/c-nat-4.wav")

@export var musical_scale: ScaleData = preload(
	"res://data/scales/pentatonic.tres"
)

var solfege_notes_of_stream: Array[SolfegeNoteData] = []


func _ready():
	solfege_notes_of_stream = musical_scale.solfege_ascending_notes
	var scale_to_build = _build_stream_sequential_from_solfege_note_data(
		solfege_notes_of_stream
	)

	$AudioStreamPlayer.set_stream(scale_to_build)

	$VBoxContainer/ContainedNotes/LineEdit.text = (
		musical_scale.solfege_ascending_string
	)


func _build_stream_sequential() -> AudioStreamRandomizer:
	var scale_to_build = AudioStreamRandomizer.new()
	scale_to_build.playback_mode = scale_to_build.PLAYBACK_SEQUENTIAL
	return scale_to_build


func _build_stream_sequential_from_solfege_note_data(
	solfege_note_data: Array[SolfegeNoteData]
) -> AudioStreamRandomizer:
	var scale_to_build = _build_stream_sequential()
	# Type of `Array[AudioStream]`.
	var audio_stream_notes_to_append_list = []
	var chromatic_index_maximum = chromatic_index_to_streams.pitch_list.size()

	if chromatic_index_maximum == 0:
		print_debug(
			'Error: chromatic_index_to_streams of ',
			chromatic_index_to_streams.description,
			' is missing audio files.'
		)

	audio_stream_notes_to_append_list = solfege_note_data.map(
		func(solfegeNote: SolfegeNoteData) -> AudioStream:
			return chromatic_index_to_streams.pitch_list[
				solfegeNote.chromatic_index % chromatic_index_maximum
			]
	)

	for note_index in audio_stream_notes_to_append_list.size():
		scale_to_build.add_stream(
			note_index,
			audio_stream_notes_to_append_list[note_index]
		)

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
