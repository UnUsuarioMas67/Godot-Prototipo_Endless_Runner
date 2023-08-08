extends Node2D

var game_manager : GameManager


func _process(delta):
	if game_manager == null:
		get_game_manager()
		if game_manager == null:
			return
	
	position.x -= game_manager.speed * delta


func get_game_manager():
	game_manager = get_tree().get_first_node_in_group("game_manager") as GameManager
