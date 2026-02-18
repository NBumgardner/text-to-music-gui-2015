extends Control

const Convert = preload("../../musical_translations/convert.gd")

var converter_methods = Convert.new()

@onready var input_control_to_translate: LineEdit = (
	$MarginContainer/VBoxContainer/RowUserInput/LineEdit
)

# Get output rows excluding the first row and last rows of user input.
@onready var play_var_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children()
		.filter(func (child): return child is ScaledSolfegePlayerFirstNote)
)

# Get output rows excluding the first 5 row of user input.
@onready var scaled_solfege_player_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children()
		.filter(func (child): return child is ScaledSolfegePlayer)
)

var _scale_in_solfege: Array[ScaleData] = []


func _ready():
	var incoming_scales_in_solfege: Array = (play_var_list.map(
		func(playVar: Node) -> ScaleData: return playVar.musical_scale
	))
	_scale_in_solfege.assign(incoming_scales_in_solfege)


func _on_scaled_solfege_player_play_button_pressed():
	for scaled_solfege_player in scaled_solfege_player_list:
		scaled_solfege_player.stop_notes()
