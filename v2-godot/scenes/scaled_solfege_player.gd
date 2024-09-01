class_name ScaledSolfegePlayer extends Control

# Copied from demo:
#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 440.0
var phase = 0.0

# Copied from demo:
#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().

@onready var play_button = $HBoxContainer/Button

@onready var audio_stream_player = $AudioStreamPlayer

@export var musical_scale: ScaleData = null


func set_line_edit_text(incoming_text: String) -> void:
	$HBoxContainer/LineEdit.text = incoming_text


# Copied from demo:
#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
func _fill_buffer() -> void:
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _ready():
	_init_note()
	audio_stream_player.stop()

	if musical_scale != null:
		$HBoxContainer/ScaleName.text = musical_scale.label_name


func _process(_delta):
	# Copied from demo:
	#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
	_fill_buffer()


func _init_note():
	_start_note(sample_hz)
	_stop_note()


func _solfege_note_to_chromatic_index(solfege_note: String) -> int:
	var solfege_strings = musical_scale.solfege_ascending_string.split(
		" ",
		false
	)
	var has_solfege_string_match = solfege_strings.has(solfege_note)

	if not has_solfege_string_match:
		return -1

	var solfege_string_match_index = solfege_strings.find(solfege_note)

	return musical_scale.solfege_ascending_notes[
		solfege_string_match_index
	].chromatic_index


func _solfege_note_to_hz(solfege_note: String) -> int:
	var chromatic_index = _solfege_note_to_chromatic_index(solfege_note)
	if chromatic_index == -1:
		return 0

	return sample_hz + 1000 * chromatic_index


func _on_button_pressed() -> void:
	if audio_stream_player.playing:
		_stop_note()
		return

	var requested_song_solfege = $HBoxContainer/LineEdit.text

	if $HBoxContainer/LineEdit.text != '' and musical_scale.solfege_ascending_string != '':
		print("Request to play:", requested_song_solfege)

	var requested_song_solfege_note_list = requested_song_solfege.split(" ")

	var targetHz = sample_hz

	if len(requested_song_solfege_note_list) == 0:
		print_debug("Empty play content is ignored.")
		return

	var first_solfege_note = requested_song_solfege_note_list[0]
	targetHz = _solfege_note_to_hz(first_solfege_note)

	print_debug("Play a new note of", first_solfege_note, "hz", targetHz)
	_start_note(targetHz)


func _start_note(hz: int) -> void:
	audio_stream_player.stream.mix_rate = hz
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()


func _stop_note() -> void:
	audio_stream_player.stop()
