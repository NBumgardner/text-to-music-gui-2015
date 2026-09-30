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


## Handle when a gamepad is plugged in or out of the game.
## Only show the onscreen keyboard while at least 1 gamepad is plugged in.
func handle_joy_connection_changed(_device: int, connected: bool):
	grab_focus_default(_device, connected)

	var no_joypads_connected = Input.get_connected_joypads().is_empty()

	if not connected and no_joypads_connected:
		text_to_music_gui.hide_onscreen_keyboard_for_gamepads()

	if not no_joypads_connected:
		text_to_music_gui.show_onscreen_keyboard_for_gamepads()
