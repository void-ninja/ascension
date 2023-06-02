extends BaseState

var direction : int = 0

func input(event : InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	elif Input.is_action_just_pressed("main_attack"):
		return State.Attack
	return State.Null
		
func physics_process(delta : float) -> int:
	
	if !player.is_on_floor():
		return State.Fall
	
	direction = 0
	if Input.is_action_pressed("left"):
		direction = -1
	elif Input.is_action_pressed("right"):
		direction = 1
	
	player.set_player_orientation(direction)
	set_player_x_velocity(direction)
	player.move_and_slide()
	
	if direction == 0:
		return State.Idle
	
	return State.Null

func set_player_x_velocity(x_direction : float):
	if x_direction:
		player.velocity.x = lerp(player.velocity.x, x_direction * player.move_speed, player.acceleration)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)
