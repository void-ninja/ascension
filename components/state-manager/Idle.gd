extends BaseState

func input(event : InputEvent) -> int:
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return State.Run
	elif Input.is_action_just_pressed("jump"):
		return State.Jump
	elif Input.is_action_just_pressed("main_attack"):
		return State.Attack
	else:
		return State.Null


func physics_process(delta : float) -> int:
#	player.velocity.y += player.gravity COMMENTED OUT because I dont know why its here
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)
	player.move_and_slide()
	
	if !player.is_on_floor():
		return State.Fall
	return State.Null
