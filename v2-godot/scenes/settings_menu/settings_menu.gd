extends MarginContainer


## Emitted when the [i]Turbo mode[/i] checkbox is toggled on or off.
signal playback_speed_toggle_requested(toggled_on: bool, multiplier: float)


@export var note_length_multiplier = 2


@onready var checkbox_playback_speed_faster = (
	$MarginContainer/VBoxContainer/CheckBoxPlaybackSpeedFaster
)


const PLAYBACK_SPEED_TEXT_PREFIX = 'Playback Speed x'


func _ready():
	if note_length_multiplier == null:
		checkbox_playback_speed_faster.hide()
		return

	checkbox_playback_speed_faster.text = (
		PLAYBACK_SPEED_TEXT_PREFIX + str(note_length_multiplier)
	)


func _on_button_close_pressed():
	self.hide()


func _on_check_box_playback_speed_faster_toggled(toggled_on):
	playback_speed_toggle_requested.emit(toggled_on, note_length_multiplier)
