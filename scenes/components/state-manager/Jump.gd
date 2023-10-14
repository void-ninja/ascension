extends BaseState

@export var jump_force : int = 325
@export var air_move_speed : int = 150

var direction : int = 0

func enter() -> void:
	super.enter() # Calls the base class enter function
	has_jumped = true
	player.velocity.y = -jump_force


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
	
	player.velocity.x = direction * air_move_speed
	player.velocity.y += player.gravity * delta
	player.velocity += current_knockback
	player.move_and_slide()
	
	if current_knockback != Vector2.ZERO:
		current_knockback.x = lerp(current_knockback.x, 0.0, 0.9)
		current_knockback.y = 0
	
	if player.velocity.y > 0:
		return State.Fall
	
	if player.is_on_floor():
		has_jumped = false
		if direction != 0:
			return State.Run
		else:
			return State.Idle
	return State.Null
