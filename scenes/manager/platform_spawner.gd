extends Node

const PLATFORM_SCENE: PackedScene = preload("res://scenes/platform/platform.tscn")
const COIN_SCENE: PackedScene = preload("res://scenes/coin/coin.tscn")

const COIN_DENSITY = 0.2

@export var game_manager: GameManager 


func _ready():
	$Platform.right_side_on_screen.connect(on_right_side_on_screen)


func generate_platform(previous_platform: Platform):
	var new_platform = PLATFORM_SCENE.instantiate() as Platform
	
	# set y position
	new_platform.position.y = previous_platform.position.y
	
	# pick a random width and height (calculated in tiles)
	var min_width = (previous_platform.viewport_width / 2) / 18
	var max_width = (previous_platform.viewport_width * 2) / 18
	var min_height = 2
	var max_height = min(8, previous_platform.height + 2)
	
	var chosen_width = randi_range(min_width, max_width)
	var chosen_height = randi_range(min_height, max_height)
	
	# pick a random distance (calculated in tiles)
	var min_distance = 2
	var max_distance = floor(game_manager.get_max_jump_distance_in_tiles() * 0.75)
	
	# if the new_platform is 2 tiles taller than the previous_platform
	# decrease the max_distance by 1 tile 
	if chosen_height - previous_platform.height == 2:
		max_distance -= 1
	# else if the new platform is 2 blocks shorter
	# increase the max_distance by 1 tile
	elif chosen_height - previous_platform.height == -2:
		max_distance += 1
	
	var chosen_distance = randi_range(min_distance, max_distance)
	
	# set x position
	new_platform.position.x = previous_platform.viewport_width + (chosen_distance * 18)
	
	# set size
	new_platform.width = chosen_width
	new_platform.height = chosen_height
	
	generate_coins(new_platform)
	
	add_child(new_platform)
	
	new_platform.right_side_on_screen.connect(on_right_side_on_screen)


func generate_coins(platform: Platform):
	var platform_top = platform.to_global(platform.map_to_local(Vector2i(0, -platform.height + 1)) - Vector2(9, 9)).y
	# set the max height for the coins to spawn (calculated in pixels)
	var max_height = max(0, platform_top - PlayerGlobals.JUMP_HEIGHT)
	
	var coin_amount = floor(COIN_DENSITY * platform.width)
	var coin_distance : float = (platform.width - 1)/ coin_amount
	
	# loop through the platform horizontal length (in tiles)
	for i in coin_amount:
		var coin = COIN_SCENE.instantiate() as Node2D
		
		coin.position.x = (coin_distance * i * 18) + 9 + ((coin_distance * 18) / 2)
		
		var chosen_height = randi_range(platform_top, max_height)
		coin.position.y = platform.to_local(Vector2(0, chosen_height)).y
		platform.add_child(coin)


func on_right_side_on_screen(platform: Platform):
	generate_platform(platform)
