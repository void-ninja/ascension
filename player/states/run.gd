extends PlayerState


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to('Air', {coyote_time=true})
	
	player.velocity.x = player.speed * player.get_x_direction()
	player.velocity.y = player.gravity * delta 
	player.move_and_slide()
	
	if Input.is_action_just_pressed('jump'):
		state_machine.transition_to('Jump')
	elif is_zero_approx(player.velocity.x):
		state_machine.transition_to('Idle')
