extends Control

const Convert = preload("../musical_translations/convert.gd")

var converter_methods = Convert.new()

@onready var input_control_to_translate: LineEdit = (
	$MarginContainer/VBoxContainer/RowUserInput/LineEdit
)

# Get output rows excluding the first row of user input.
@onready var play_var_list: Array[Node] = (
	$MarginContainer/VBoxContainer.get_children().slice(1)
)

var _scale_in_solfege: Array[ScaleData] = []


func _ready():
	var incoming_scales_in_solfege: Array = (play_var_list.map(
		func(playVar: Node) -> ScaleData: return playVar.musical_scale
	))
	_scale_in_solfege.assign(incoming_scales_in_solfege)
