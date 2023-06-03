extends BaseState


const ATTACK_COOLDOWN_MAX : float = 0.4 # in seconds
var attack_cooldown_timer : float = 0

@export var attack_friction_modifier : float = 1

var is_animation_finished : bool = false
var is_animation_connected : bool = false

func enter():
	player.animation_player.stop()
	super.enter()
	attack_cooldown_timer = ATTACK_COOLDOWN_MAX
	is_animation_finished = false
	if is_animation_connected == false:
		player.animation_player.animation_finished.connect(_on_animation_finished)
		is_animation_connected = true

	
func physics_process(delta):
	if is_animation_finished:
		return State.Idle
	
	if attack_cooldown_timer == 0:
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			return State.Run
		elif Input.is_action_pressed("jump") and has_jumped == false:
			return State.Jump
		elif Input.is_action_pressed("main_attack"):
			return State.Attack2
	
	player.velocity.x = lerp(player.velocity.x, 0.0, (attack_friction_modifier * player.friction))
	player.velocity.y += player.gravity * delta
	attack_cooldown_timer = max(attack_cooldown_timer - delta, 0)
	
	player.move_and_slide()
	
	return State.Null


func _on_animation_finished(animation):
	is_animation_finished = true
