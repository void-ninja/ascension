extends PlayerState

var is_fast_fall = false
var is_coyote_time = false
var is_jump_buffer_active = false

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer

func enter(msg := {}) -> void:
	if msg.has('fast_fall'):
		is_fast_fall = true
	else:
		is_fast_fall = false
	if msg.has('coyote_time'):
		is_coyote_time = true
		coyote_timer.wait_time = player.coyote_time_len
		coyote_timer.connect('timeout', end_coyote_time)
		coyote_timer.start()
	else: 
		is_coyote_time = false


func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed('jump'):
		if is_coyote_time:
			state_machine.transition_to('Jump')
		else:
			is_jump_buffer_active = true
			jump_buffer_timer.wait_time = player.jump_buffer_len
			jump_buffer_timer.connect('timeout', end_jump_buffer)
			jump_buffer_timer.start
	
	if player.velocity.y < 0 and is_fast_fall:
		player.velocity.y += player.fast_fall_gravity * delta
	else:
		player.velocity.y += player.gravity * delta
		is_fast_fall = false
	
	player.velocity.x = player.air_speed * player.get_x_direction()
	player.velocity.y = min(player.velocity.y, player.max_fall_speed)
	
	player.move_and_slide()

	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")


func end_coyote_time() -> void:
	is_coyote_time = false
	coyote_timer.disconnect('timeout', end_coyote_time)


func end_jump_buffer() -> void:
	is_jump_buffer_active = false
	jump_buffer_timer.disconnect('timeout', end_jump_buffer)
