extends Control


# Get output rows excluding the first row of user input.
@onready var scaled_solfege_player_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children()
		.filter(func (child): return child is ScaledSolfegePlayer)
)


func _on_scaled_solfege_player_play_button_pressed():
	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.stop_notes()
