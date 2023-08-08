
extends TileMap

@export_category("Platform Tile Size")
@export_range(2, 100, 1, "or greater", "suffix:blocks") var width: int = 2 : set = set_width
@export_range(2, 100, 1, "or greater", "suffix:blocks") var height: int = 2 : set = set_height


func _ready():
	paint_tiles()


func set_height(value):
	height = value
	paint_tiles()


func set_width(value):
	width = value
	paint_tiles()


func paint_tiles():
	var cells: Array[Vector2i] = []
	
	for w in width:
		for h in height:
			cells.append(Vector2i(w, -h))
	
	# remove all cells
	clear_layer(0)
	set_cells_terrain_connect(0, cells, 0, 0, false)
