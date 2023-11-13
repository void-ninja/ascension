extends CharacterBody2D



var damage : int = 15
var knockback_strength : int = 400
var invincibility_seconds = 0.3
@export var max_health : int = 100
@export var speed : float = 60

var direction : Vector2 = Vector2.RIGHT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: Area2D = $HitboxComponent
@onready var hurtbox_component: Area2D = $HurtboxComponent
@onready var health_bar_component: HealthBar = $HealthBarComponent

var current_knockback : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox_component.damage = damage
	hitbox_component.knockback_strength = knockback_strength
	health_component.max_health = max_health
	hurtbox_component.invincibility_seconds = invincibility_seconds
	health_bar_component.health_bar.max_value = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if -0.1 < current_knockback.x and current_knockback.x < 0.1:
		if -1 < direction.x and direction.x < 1:
			velocity.x = 0
		elif direction.x > 0:
			velocity.x = speed
		elif direction.x < 0:
			velocity.x = -1 * speed
		else:
			velocity.x = 0
			
		if is_on_floor() and !$RayCast2D.is_colliding():
			$RayCast2D.position.x *= -1
			$Sprite2D.flip_h = not $Sprite2D.flip_h
			direction.x *= -1
	
	if velocity.x != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		
	velocity += current_knockback
	move_and_slide()
	
	if current_knockback != Vector2.ZERO:
		current_knockback.x = lerp(current_knockback.x, 0.0, 0.5)
		current_knockback.y = 0
	
	if is_on_wall():
		$RayCast2D.position.x *= -1
		$Sprite2D.flip_h = not $Sprite2D.flip_h
		direction.x *= -1
	
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_hurtbox_component_knockback(kb_direction, strength) -> void:
	kb_direction.y = -0.2
	current_knockback = kb_direction * strength
	if direction.x > 0 and kb_direction.x > 0:
		pass
	elif direction.x < 0 and kb_direction.x < 0:
		pass
	else:
		$RayCast2D.position.x *= -1
		$Sprite2D.flip_h = not $Sprite2D.flip_h
		direction *= -1


func _on_health_component_damaged(amount, current) -> void:
	health_bar_component.health = current


func _on_health_component_healed(amount, current) -> void:
	health_bar_component.health = current
