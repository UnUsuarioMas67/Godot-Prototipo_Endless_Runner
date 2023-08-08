extends Node2D

var game_manager: GameManager

var is_coin_passed := false
var player



func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	player = get_player()


func _process(delta):
	if player == null:
		player = get_player()
		if player == null:
			return
	
	if !is_coin_passed && global_position.x < player.global_position.x - 18:
		is_coin_passed = true
		GameEvents.coin_passed.emit()
		print_debug("coin passed")
	

#func lerp_to_player(weight: float, start_position: Vector2):
#	var player = get_player()
#	if player == null:
#		return
#
#	# set top_level to true so the coin stops inhereting it's parent platform position
#	if !top_level:
#		top_level = true
#
#	global_position = start_position.lerp(player.global_position, weight)


func get_player() -> Node2D:
	return get_tree().get_first_node_in_group("player") as Node2D


func disable_collision():
	$Area2D/CollisionShape2D.disabled = true


func collect():
	GameEvents.coin_collected.emit()
	queue_free()


func on_area_entered(area: Area2D):
	collect()
#	Callable(disable_collision).call_deferred()
#
#	var tween = create_tween().set_parallel(true)
##	tween.tween_method(lerp_to_player.bind(global_position), 0.0, 1.0, .5)
#	tween.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, .25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
#	tween.tween_callback(collect)
#
#	tween.chain().tween_callback(queue_free)
