extends Control


# Get output rows excluding the first row of user input.
@onready var scaled_solfege_player_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children()
		.filter(func (child): return child is ScaledSolfegePlayer)
)


@onready var settings_menu = $SettingsMenu


func _ready():
	settings_menu.visible = false


func _on_button_settings_pressed():
	settings_menu.visible = !settings_menu.visible


func _on_scaled_solfege_player_play_button_pressed():
	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.stop_notes()


func _on_settings_menu_turbo_mode_toggle_requested(toggled_on):
	if toggled_on:
		for scaled_solfege_player in scaled_solfege_player_list:
			scaled_solfege_player.note_length_seconds = (
				scaled_solfege_player.note_length_seconds / 2
			)
	else:
		for scaled_solfege_player in scaled_solfege_player_list:
			scaled_solfege_player.note_length_seconds = (
				scaled_solfege_player.note_length_seconds * 2
			)
