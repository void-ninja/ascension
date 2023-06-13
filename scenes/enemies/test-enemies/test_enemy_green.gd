extends CharacterBody2D


@export var speed : float = 60

var direction : Vector2 = Vector2.RIGHT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if -1 < direction.x and direction.x < 1:
		velocity.x = 0
	elif direction.x > 0:
		velocity.x = 1 * speed
	elif direction.x < 0:
		velocity.x = -1 * speed
	else:
		velocity.x = 0
	
	if velocity.x != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		
	
	move_and_slide()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_wall() or (is_on_floor() and !$RayCast2D.is_colliding()):
		$RayCast2D.position.x *= -1
		$Sprite2D.flip_h = not $Sprite2D.flip_h
		direction *= -1
