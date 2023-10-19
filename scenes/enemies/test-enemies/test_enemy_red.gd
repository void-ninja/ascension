extends CharacterBody2D


@export var speed : float = 60

var damage : int = 10
var knockback_strength : int = 300
var invincibility_seconds = 0.1
@export var max_health : int = 80

var direction : Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: Area2D = $HitboxComponent
@onready var hurtbox_component: Area2D = $HurtboxComponent

var current_knockback : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox_component.damage = damage
	hitbox_component.knockback_strength = knockback_strength
	health_component.max_health = max_health
	hurtbox_component.invincibility_seconds = invincibility_seconds


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if -0.2 < current_knockback.x and current_knockback.x < 0.2:
		direction = get_direction_to_player()
		
		if -1 < direction.x and direction.x < 1:
			velocity.x = 0
		elif direction.x > 0:
			velocity.x = 1 * speed
		elif direction.x < 0:
			velocity.x = -1 * speed
		else:
			velocity.x = 0
		
		set_orientation(direction.x)
	
	if velocity.x != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		
	velocity += current_knockback
	move_and_slide()
	
	if current_knockback != Vector2.ZERO:
		current_knockback.x = lerp(current_knockback.x, 0.0, 0.6)
		current_knockback.y = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null: # if the player is alive
		return player.global_position - global_position
	return Vector2.ZERO


func set_orientation(x_direction : float):
	if x_direction < 0 :
		$Sprite2D.flip_h = true
	elif x_direction > 0:
		$Sprite2D.flip_h = false


func _on_hurtbox_component_knockback(kb_direction, strength) -> void:
	kb_direction.y = -0.2
	current_knockback = kb_direction * strength
	if direction.x > 0 and kb_direction.x > 0:
		pass
	elif direction.x < 0 and kb_direction.x < 0:
		pass
	else:
		$Sprite2D.flip_h = not $Sprite2D.flip_h
