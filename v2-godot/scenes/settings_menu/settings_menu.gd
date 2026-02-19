extends MarginContainer


## Emitted when the [i]Turbo mode[/i] checkbox is toggled on or off.
signal turbo_mode_toggle_requested(toggled_on: bool)


@onready var turbo_mode_description = $VBoxContainer/TurboModeDescription


func _ready():
	turbo_mode_description.set_modulate(Color(255, 255, 255, 0))


func _on_check_box_toggled(toggled_on: bool) -> void:
	turbo_mode_toggle_requested.emit(toggled_on)
	turbo_mode_description.set_modulate(Color(255, 255, 255, 255))
