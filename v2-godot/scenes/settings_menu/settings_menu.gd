extends MarginContainer


## Emitted when a change in playback speed multiplier setting is requested.
signal playback_speed_multiplier_change_requested(
	playback_speed_multiplier: float
)


func _on_check_box_playback_speed_faster_toggled(toggled_on):
	if not toggled_on:
		playback_speed_multiplier_change_requested.emit(1.0)
		return

	playback_speed_multiplier_change_requested.emit(2.0)
