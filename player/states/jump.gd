extends PlayerState 
 
@export var timer : Timer

func enter(_msg := {}) -> void:
	timer.wait_time = player.jump_max_len
	timer.connect('timeout', end_jump)
	timer.start()
	player.velocity.y = player.jump_force


func physics_update(delta: float) -> void:
	player.velocity.x = player.air_speed * player.get_x_direction()
	
	player.velocity.y += player.jump_gravity * delta
	player.move_and_slide()
	if Input.is_action_just_released("jump"):
		timer.disconnect('timeout', end_jump)
		state_machine.transition_to('Air',{fast_fall=true})
		


func end_jump():
	timer.disconnect('timeout', end_jump)
	state_machine.transition_to('Air')
