extends BaseState

@export var JUMP_FORCE : int = 325
@export var AIR_MOVE_SPEED : int = 150

@export var JUMP_HANG_TIME_THRESHOLD : int = -60
@export var JUMP_HANG_VEL_MULT : float = 0.5
@export var JUMP_HANG_X_VEL_MULT : float  = 1.2

@export var SHORT_JUMP_GRAV_MULT  : float = 2.2

@export var INVERT_ANIM_THRESHOLD : int = -30

var direction : int = 0

var is_animation_finished : bool = false
var is_animation_connected : bool = false

func enter() -> void:
	animation_name = animation_set[Animations.Launch]
	super.enter() # Calls the base class enter function
	has_jumped = true
	player.velocity.y = -JUMP_FORCE
	
	is_animation_finished = false
	if is_animation_connected == false:
		player.animation_player.animation_finished.connect(_on_animation_finished)
		is_animation_connected = true


func input(event : InputEvent):
	if Input.is_action_just_pressed("main_attack"):
		return State.Attack
		
	return State.Null

func physics_process(delta : float):
	
	direction = 0
	if Input.is_action_pressed("left"):
		direction = -1
	elif Input.is_action_pressed("right"):
		direction = 1
	
	player.set_player_orientation(direction)
	
	player.velocity.x = direction * AIR_MOVE_SPEED
	if player.velocity.y > JUMP_HANG_TIME_THRESHOLD: # extra airtime and bonus peak speed
		player.velocity.y += (player.gravity * JUMP_HANG_VEL_MULT) * delta
		player.velocity.x = player.velocity.x * JUMP_HANG_X_VEL_MULT
	elif Input.is_action_pressed("jump"): # variable jump height
		player.velocity.y += player.gravity * delta
	else:
		player.velocity.y += (player.gravity * SHORT_JUMP_GRAV_MULT) * delta
	player.move_and_slide()
	
	if player.velocity.y > INVERT_ANIM_THRESHOLD:
		animation_name = animation_set[Animations.Invert]
		player.animation_player.play(animation_name)
	
	if player.velocity.y > 0:
		return State.Fall
	
	if player.is_on_floor():
		has_jumped = false
		if direction != 0:
			return State.Run
		else:
			return State.Idle
	return State.Null


func _on_animation_finished(anim_name):
	animation_name = animation_set[Animations.Fly]
	player.animation_player.play(animation_name)
