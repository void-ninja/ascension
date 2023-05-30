extends CharacterBody2D


@export var speed : float = 60

var direction : Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		
	
	move_and_slide()
	
	if not is_on_floor():
		velocity.y += gravity * delta


func on_area_entered(other_area: Area2D):
	queue_free()


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return player.global_position - global_position
	print("test_enemy_red : player is null")
	return Vector2.ZERO


func set_orientation(x_direction : float):
	if x_direction < 0 :
		$Sprite2D.flip_h = true
	elif x_direction > 0:
		$Sprite2D.flip_h = false
