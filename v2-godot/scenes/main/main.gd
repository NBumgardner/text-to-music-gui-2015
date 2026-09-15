extends Control


@onready var text_to_music_gui = $TextToMusicGui


func _ready():
	Input.joy_connection_changed.connect(grab_focus_default)


## Grab focus on the default first control, to call when a controller is plugged
##  in.
func grab_focus_default(_device: int, connected: bool):
	if not connected:
		return

	text_to_music_gui.grab_focus_default()
