@tool
extends TileMap
class_name Platform

signal right_side_on_screen(platform: Platform)

@export_category("Platform Size")
@export_range(2, 100, 1, "or greater", "suffix:blocks") var width: int = 2 : set = set_width
@export_range(2, 100, 1, "or greater", "suffix:blocks") var height: int = 2 : set = set_height

@onready var viewport_width = get_viewport_rect().end.x

var _is_right_side_on_screen = false
var game_manager : GameManager


func set_height(value):
	height = value
	if Engine.is_editor_hint():
		update_size()


func set_width(value):
	width = value
	if Engine.is_editor_hint():
		update_size()


func _ready():
	update_size()


func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if game_manager == null:
		get_game_manager()
		if game_manager == null:
			return
	
	position.x -= game_manager.speed * delta
	
	if position.x + get_pixel_width() <= viewport_width && !_is_right_side_on_screen:
		_is_right_side_on_screen = true
		right_side_on_screen.emit(self)
	
	# remove the platform once it exits the screen
	if position.x + get_pixel_width() <= -10:
		queue_free()


func update_size():
	var cells: Array[Vector2i] = []
	
	for w in width:
		for h in height:
			cells.append(Vector2i(w, -h))
	
	# remove all cells
	clear_layer(0)
	set_cells_terrain_connect(0, cells, 0, 0, false)


func get_pixel_width() -> int:
	return get_used_rect().size.x * 18


func get_game_manager():
	game_manager = get_tree().get_first_node_in_group("game_manager") as GameManager
