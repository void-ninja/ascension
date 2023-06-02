extends CharacterBody2D
class_name Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var attack_area : Area2D = $Attack
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_manager : Node = $StateManager

@export var move_speed : int = 150
@export_range(0.0,1.0) var friction = 0.2
@export_range(0.0,1.0) var acceleration = 0.25

func _ready():
	$Attack/Hurtbox.disabled = true # Figure out if I still need this when I implement attack state
	# Initialize the state machine passing a reference to the player
	state_manager.init(get_node("."))
	
	
func _input(event):
	state_manager.input(event)


func _physics_process(delta):
	state_manager.physics_process(delta)


func set_player_orientation(x_direction : float): 
	# Negative values are left, positive are right
	if x_direction < 0 :
		$Sprite2D.flip_h = true
		if $Attack.scale.x > 0: # Flip the attack hurtbox to the player orientation
			$Attack.scale.x *= -1
	elif x_direction > 0:
		$Sprite2D.flip_h = false
		if $Attack.scale.x < 0:
			$Attack.scale.x *= -1
