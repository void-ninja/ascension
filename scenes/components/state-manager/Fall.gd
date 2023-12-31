extends BaseState

@export var move_speed : int = 150

var direction : int = 0

const COYOTE_TIME_MAX : float = 0.1 # in seconds
var coyote_timer : float = COYOTE_TIME_MAX

const JUMP_BUFFER_MAX : float = 0.08 # in seconds
var jump_buffer_timer : float = 0

var is_animation_finished : bool = false
var is_animation_connected : bool = false

func enter():
	animation_name = animation_set[Animations.Fall]
	super.enter()
	coyote_timer = COYOTE_TIME_MAX
	is_animation_finished = false


func input(event : InputEvent):
	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		if has_jumped == false:
			return State.Jump
	elif Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_MAX
	elif Input.is_action_just_pressed("main_attack"):
		return State.Attack
		
	return State.Null


func physics_process(delta : float):
	direction = 0
	if Input.is_action_pressed("left"):
		direction = -1
	elif Input.is_action_pressed("right"):
		direction = 1
	
	if not player.is_on_floor():
		jump_buffer_timer -= 1 * delta
		coyote_timer -= 1 * delta
	
	player.set_player_orientation(direction)
	
	player.velocity.x = direction * move_speed
	if has_jumped: # fast fall if jumped
		player.velocity.y += player.gravity * 1.4 * delta
	else:
		player.velocity.y += player.gravity * delta
	
	player.velocity.y = min(player.velocity.y, 365) # max fall speed
	
	player.move_and_slide()

	if player.is_on_floor():
		has_jumped = false
		if jump_buffer_timer > 0:
			return State.Jump
		if direction != 0:
			return State.Run
		else:
			if is_animation_finished == true:
				return State.Idle
			animation_name = animation_set[Animations.Landing]
			player.animation_player.play(animation_name)
			if !is_animation_connected: 
				is_animation_connected = true
				player.animation_player.animation_finished.connect(_on_animation_finished)
			
	return State.Null


func _on_animation_finished(anim_name):
	is_animation_finished = true
