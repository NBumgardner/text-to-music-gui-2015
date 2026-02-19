extends MarginContainer


## Emitted when the [i]Turbo mode[/i] checkbox is toggled on or off.
signal turbo_mode_toggle_requested(toggled_on: bool)


func _on_check_box_playback_speed_faster_toggled(toggled_on):
	turbo_mode_toggle_requested.emit(toggled_on)
