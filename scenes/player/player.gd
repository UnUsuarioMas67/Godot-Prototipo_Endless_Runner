extends CharacterBody2D

var jump_velocity
var jump_gravity 
var fall_gravity 

@onready var animation = $AnimatedSprite2D
@onready var wall_check: RayCast2D = $WallCheck


func _ready():
	$HazardDetector.hit.connect(on_hit)
	GameEvents.out_of_coins.connect(on_out_of_coins)
	
	jump_velocity = ((2.0 * PlayerGlobals.JUMP_HEIGHT) / PlayerGlobals.TIME_TO_PEAK) * -1.0
	jump_gravity = ((-2.0 * PlayerGlobals.JUMP_HEIGHT) / (PlayerGlobals.TIME_TO_PEAK * PlayerGlobals.TIME_TO_PEAK)) * -1.0
	fall_gravity = ((-2.0 * PlayerGlobals.JUMP_HEIGHT) / (PlayerGlobals.TIME_TO_FALL * PlayerGlobals.TIME_TO_FALL)) * -1.0


func _process(delta):
	if !is_on_floor():
		animation.play("air")
	else:
		animation.play("ground")


func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity
	
	apply_gravity(delta)
	move_and_slide()
	
	var screen_bottom = get_viewport_rect().end.y
	
	if wall_check.is_colliding() or global_position.y >= screen_bottom + 24:
		die()
#	if is_on_wall_only():
#		die()


func apply_gravity(delta: float):
	var gravity
	
	if velocity.y < 0:
		gravity = jump_gravity * delta
	else:
		gravity = fall_gravity * delta
	
	# jump release
	if not Input.is_action_pressed("jump") and velocity.y < 0:
		gravity *= 3.33
		
	velocity.y += gravity


func die():
	GameEvents.player_died.emit()
	queue_free()


func on_hit():
	die()


func on_out_of_coins():
	die()
