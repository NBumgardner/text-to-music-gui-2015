extends Button

var key_data

signal released
signal down

var icon_tex_rect

@export var focused:bool = false:
	set(new_val):
		focused = new_val
	get:
		return focused
@export var pressing:bool = false:
	set(new_val):
		pressing = new_val
	get:
		return pressing
var id_x = 0
var id_y = 0

func set_focused(_focused):
	focused = _focused
	queue_redraw()

func set_pressing(_pressing):
	if pressing != _pressing:
		if _pressing:
			emit_signal("button_down")
		else:
			emit_signal("button_up")
	pressing = _pressing
	queue_redraw()

func _enter_tree():
	pass

func _ready():
	pass # Replace with function body.

func _draw():
	var style = get_theme_stylebox("normal")
	if pressing or get_draw_mode() == DRAW_PRESSED or (toggle_mode and pressed):
		draw_style_box(get_theme_stylebox("pressed"), Rect2(Vector2.ZERO, size))
	else:
		draw_style_box(style, Rect2(Vector2.ZERO, size))
	if focused:
		draw_style_box(get_theme_stylebox("focus"), Rect2(Vector2.ZERO, size))
	var font = get_theme_font("font")
	var text_ofs = ((size - style.get_minimum_size() - font.get_string_size(text)) / 2.0) + style.get_offset();
	text_ofs.y += font.get_ascent();
	font.draw(get_canvas_item(), text_ofs, text)

func _init(_key_data):
	key_data = _key_data
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	item_rect_changed.connect(_on_item_rect_changed)

	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL

	focus_mode = FOCUS_NONE

	if key_data.has("display"):
		text = key_data.get("display")

	if key_data.has("stretch-ratio"):
		size_flags_stretch_ratio = key_data.get("stretch-ratio")


func set_icon_color(color):
	if icon_tex_rect != null:
		icon_tex_rect.modulate = color


func set_icon(texture):
	icon_tex_rect = TextureRect.new()
	icon_tex_rect.ignore_texture_size = true
	icon_tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_tex_rect.texture = texture
	add_child(icon_tex_rect)


func change_uppercase(value):
	if value:
		if key_data.has("display-uppercase"):
			text = key_data.get("display-uppercase")
	else:
		if key_data.has("display"):
			text = key_data.get("display")


func _on_item_rect_changed():
	if icon_tex_rect != null:
		icon_tex_rect.size = size


func _on_button_up():
	released.emit(key_data, id_x, id_y)
	release_focus()


func _on_button_down():
	down.emit(key_data, id_x, id_y)
