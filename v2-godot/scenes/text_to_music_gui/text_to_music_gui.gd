extends Control


@onready var onscreen_keyboard_wrapper = $MarginContainerBottomCenter


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

	if OS.has_feature('pc'):
		_remove_virtual_keyboard()


func _on_button_settings_pressed():
	sfx_selection_made.play()
	settings_menu.visible = !settings_menu.visible


func _on_scaled_solfege_player_play_button_pressed():
	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.stop_notes()


func _on_button_mouse_entered():
	sfx_mouse_hover.play()


## When toggling on, play notes twice as fast by lasting half as long.
## When toggling off, invert the multiplication to restore original note
##  lengths.
func _on_settings_menu_playback_speed_toggle_requested(toggled_on, multiplier):
	var note_length_multiplier = multiplier

	if toggled_on:
		note_length_multiplier = 1.0 / note_length_multiplier

	_set_note_lengths_by_multiplier(note_length_multiplier)


## Remove virtual keyboard.
## To be called once for platforms that never need it.
func _remove_virtual_keyboard():
	self.remove_child(onscreen_keyboard_wrapper)


## Adjust each [ScaledSolfegePlayer]'s audio playback note length by multiplying
##  by [multiplier].
func _set_note_lengths_by_multiplier(multiplier):
	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.note_length_seconds = (
			scaled_solfege_player.note_length_seconds * multiplier
		)
