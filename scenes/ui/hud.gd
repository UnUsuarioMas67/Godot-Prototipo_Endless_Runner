extends CanvasLayer

@export var game_manager: GameManager

@onready var score = $MarginContainer/Score
@onready var coins = $MarginContainer/Coins


func _ready():
	game_manager.coins_changed.connect(on_coins_changed)
	game_manager.score_changed.connect(on_score_changed)
	
	coins.text = "%02d" % game_manager.coins
	score.text = "%012d" % game_manager.score


func on_coins_changed(current_coins: int):
	coins.text = "%02d" % current_coins


func on_score_changed(current_score: int):
	score.text = "%012d" % current_score
