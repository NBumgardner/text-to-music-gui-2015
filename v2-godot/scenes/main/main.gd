extends Control


@onready var text_to_music_gui = $TextToMusicGui


func _ready():
	Input.joy_connection_changed.connect(handle_joy_connection_changed)


## Grab focus on the default first control, to call when a controller is plugged
##  in.
func grab_focus_default(_device: int, connected: bool):
	if not connected:
		return

	text_to_music_gui.grab_focus_default()


func handle_joy_connection_changed(_device: int, connected: bool):
	grab_focus_default(_device, connected)

	if not connected and Input.get_connected_joypads().is_empty():
		text_to_music_gui.hide_onscreen_keyboard_for_gamepads()
