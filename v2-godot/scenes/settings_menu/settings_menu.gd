extends MarginContainer


## Emitted when the [i]Turbo mode[/i] checkbox is toggled on or off.
signal turbo_mode_toggle_requested(toggled_on: bool)


func _on_check_box_toggled(toggled_on: bool) -> void:
	turbo_mode_toggle_requested.emit(toggled_on)
