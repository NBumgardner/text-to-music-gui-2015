extends Control

var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 440.0
var phase = 0.0

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().

@onready var play_button = $HBoxContainer/Button

@onready var audio_stream_player = $AudioStreamPlayer

@export var musical_scale: ScaleData = null


# Copied from demo:
#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _ready():
	_play_note_forever()
	audio_stream_player.stop()
	
	if musical_scale != null:
		$HBoxContainer/ScaleName.text = musical_scale.label_name


func _process(delta):
	# Copied from demo:
	#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
	_fill_buffer()


func _on_button_pressed():
	if audio_stream_player.playing:
		audio_stream_player.stop()
		return

	print_debug("Play a new note")
	_play_note_forever()


# Copied from demo:
#  https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/audio/generator/generator_demo.gd
func _play_note_forever():
	audio_stream_player.stream.mix_rate = sample_hz
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()
	
