extends CharacterBody2D


@export var speed : float = 150
@export var jump_velocity : float = -325
@export_range(0.0,1.0) var friction = 0.1
@export_range(0.0,1.0) var acceleration = 0.25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

const COYOTE_TIME_MAX : float = 0.1 # in seconds
var coyote_timer : float = COYOTE_TIME_MAX

const JUMP_BUFFER_MAX : float = 0.06 # in seconds
var jump_buffer_timer : float = 0

const ATTACK_COOLDOWN_MAX : float = 0.5 # in seconds
var attack_cooldown_timer : float = 0

func _ready():
	$AnimationTree.active = true
	$Attack/Hurtbox.disabled = true

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	set_player_velocity(direction.x)

	if attack_cooldown_timer == 0:
		set_player_animation(direction)
		set_player_orientation(direction.x)	
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * 2)
		attack_cooldown_timer = max(attack_cooldown_timer - 1 * delta, 0)
		
	check_for_player_attack()
		
	move_and_slide() 
	# Important that is_on_floor() checks come after move_and_slide(), 
	# because it determines that state for the current frame.

	if not is_on_floor():
		velocity.y += gravity * delta
	
	handle_jump(delta)
	

func set_player_orientation(x_direction : float):
	if x_direction < 0 :
		$Sprite2D.flip_h = true
		if $Attack.scale.x > 0: # Flip the attack hurtbox to the player orientation
			$Attack.scale.x *= -1
	elif x_direction > 0:
		$Sprite2D.flip_h = false
		if $Attack.scale.x < 0:
			$Attack.scale.x *= -1

func set_player_velocity(x_direction : float):
	if x_direction:
		velocity.x = lerp(velocity.x, x_direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)


func set_player_animation(player_direction : Vector2) :
	if player_direction == Vector2.ZERO:
		$AnimationTree.set("parameters/Movement/transition_request", "Idle")
	else:
		$AnimationTree.set("parameters/Movement/transition_request", "Run")
		$AnimationTree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


func check_for_player_attack():
	if Input.is_action_just_pressed("main_attack") and attack_cooldown_timer == 0:
		$AnimationTree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_cooldown_timer = ATTACK_COOLDOWN_MAX


func handle_jump(delta_time):
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_MAX
	
	# Coyote time handling (aka jump grace)
	if is_on_floor():
		coyote_timer = COYOTE_TIME_MAX
	else:
		coyote_timer = max(coyote_timer - 1 * delta_time, 0)

	if jump_buffer_timer > 0:
		if is_on_floor() or coyote_timer > 0:
			velocity.y = jump_velocity
			jump_buffer_timer = 0
		jump_buffer_timer -= 1 * delta_time

