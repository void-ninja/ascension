extends BaseState

var knockback:Vector2

func enter():
	animation_name = animation_set[Animations.Idle]
	super.enter()


func physics_process(delta: float) -> int:
	player.velocity += knockback
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if knockback.x > 1:
		knockback.x = lerp(knockback.x, 0.0, 0.6)
		knockback.y = 0
		print_debug(knockback)
		return State.Null
	else: return State.Idle
	
