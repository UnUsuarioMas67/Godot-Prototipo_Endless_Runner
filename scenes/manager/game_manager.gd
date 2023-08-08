extends Node
class_name GameManager

signal coins_changed(current_coins)
signal score_changed(current_score)


const INITIAL_SPEED : float = 100.0
const SPEED_INCREASE : float = 10.0
const STARTING_COINS = 5

var speed : float
var speed_level : int = 0
var coins : int = 0
var score : int = 0

var tween: Tween


func _ready():
	$SpeedTimer.timeout.connect(on_speed_timer_timeout)
	$ScoreTimer.timeout.connect(on_score_timer_timeout)
	
	GameEvents.coin_collected.connect(on_coin_collected)
	GameEvents.player_died.connect(on_player_died)
	GameEvents.coin_passed.connect(on_coin_passed)
	
	speed = INITIAL_SPEED
	coins = STARTING_COINS


func _physics_process(delta):
	score += 1 * (speed / 100)
	score_changed.emit(score)


func get_max_jump_distance_in_tiles() -> int:
	return floor((speed * (PlayerGlobals.TIME_TO_PEAK + PlayerGlobals.TIME_TO_FALL)) / 18)


func on_speed_timer_timeout():
	speed_level += 1
	
	tween = create_tween()
	tween.tween_property(self, "speed", INITIAL_SPEED + (SPEED_INCREASE * speed_level), 1)


func on_score_timer_timeout():
	score += 10 * (speed / 100)
	score_changed.emit(score)
	print_debug(score)


func on_coin_collected():
	coins += 1
	coins_changed.emit(coins)
	print_debug(coins)


func on_coin_passed():
	coins -= 2
	if coins <= 0:
		coins = 0
		GameEvents.out_of_coins.emit()
	
	coins_changed.emit(coins)
	
	print_debug(coins)


func on_player_died():
	if tween != null:
		if tween.is_running() or tween.is_valid():
			tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "speed", 0, 0.1)
#	speed = 0
	$SpeedTimer.stop()
	$ScoreTimer.stop()
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
