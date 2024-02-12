extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to('Air')
	
	player.velocity.y = player.gravity * delta
	player.move_and_slide()
		
	if Input.is_action_just_pressed('jump'):
		state_machine.transition_to('Jump')
	elif Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right'):
		state_machine.transition_to('Run')
