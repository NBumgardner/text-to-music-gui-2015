extends Control


# Get output rows excluding the first row of user input.
@onready var scaled_solfege_player_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children()
		.filter(func (child): return child is ScaledSolfegePlayer)
)


@onready var settings_menu = $SettingsMenu


@onready var sfx_mouse_hover = $SfxMouseHover


@onready var sfx_selection_made = $SfxSelectionMade


func _ready():
	settings_menu.visible = false


func _on_button_settings_pressed():
	sfx_selection_made.play()
	settings_menu.visible = !settings_menu.visible


func _on_scaled_solfege_player_play_button_pressed():
	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.stop_notes()


func _on_settings_menu_turbo_mode_toggle_requested(toggled_on):
	# When toggling on, play notes twice as fast by lasting half as long.
	var note_length_multiplier = 0.5
	
	if not toggled_on:
		# When toggling off, invert the multiplication to restore original note
		#  lengths.
		note_length_multiplier = 1 / note_length_multiplier

	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.note_length_seconds = (
			scaled_solfege_player.note_length_seconds * note_length_multiplier
		)


func _on_button_mouse_entered():
	sfx_mouse_hover.play()
