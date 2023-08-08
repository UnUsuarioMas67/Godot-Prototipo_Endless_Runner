extends Node2D


func _ready():
	GameEvents.player_died.connect(on_player_died)
	
	$DeathParticle.one_shot = true
	$DeathParticle.emitting = false


func on_player_died():
	var owner_parent = owner.get_parent()
	var spawn_position = global_position
	
	owner.remove_child(self)
	owner_parent.add_child(self)
	
	global_position = spawn_position
	
	$AnimationPlayer.play("death")
