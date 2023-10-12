extends BaseState

func enter():
	animation_name = animation_set[Animations.Idle]
	super.enter()


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
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)
	player.velocity += current_knockback
	player.move_and_slide()
	
	if current_knockback != Vector2.ZERO:
		current_knockback.x = lerp(current_knockback.x, 0.0, 0.7)
		current_knockback.y = 0

	
	if !player.is_on_floor():
		return State.Fall
	return State.Null
