extends CharacterBody2D
class_name Player

signal toggle_inventory()

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hitbox_component : Area2D = $HitboxComponent
@onready var sprite : Sprite2D = $PlayerSprite
@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var state_manager : Node = $StateManager
@onready var health_component: Node = $HealthComponent

@export var inventory_data: InventoryData
@export var armor_inventory_data: InventoryDataArmor
@export var weapon_inventory_data: InventoryDataWeapon

@export var unarmed_weapon: SlotData

@export var move_speed : int = 150
var friction = 0.2
var acceleration = 0.25

var current_weapon: SlotData : 
	set(value):
		current_weapon = value
		state_manager.current_weapon = value
		state_manager.set_animation_list()
		hitbox_component.damage = value.item_data.damage
		if state_manager.current_state:
			state_manager.reset_state()


func _ready():
	PlayerManager.player = self
	hitbox_component.get_node("PunchHitbox").disabled = true
	hitbox_component.get_node("SwordHitbox").disabled = true
	# Initialize the state machine passing a reference to the player
	current_weapon = unarmed_weapon
	state_manager.init(self)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_action_just_pressed("open_inventory"):
		toggle_inventory.emit()
	state_manager.input(event)


func _physics_process(delta):
	state_manager.physics_process(delta)


func set_player_orientation(x_direction : float): 
	# Negative values are left, positive are right
	if x_direction < 0 :
		sprite.flip_h = true
		weapon_sprite.flip_h = true
		if hitbox_component.scale.x > 0: # Flip the attack hurtbox to the player orientation
			hitbox_component.scale.x *= -1
	elif x_direction > 0:
		sprite.flip_h = false
		weapon_sprite.flip_h = false
		if hitbox_component.scale.x < 0:
			hitbox_component.scale.x *= -1


func get_drop_position() -> Vector2:
	if sprite.flip_h:
		return Vector2((global_position.x - 30), global_position.y)
	else: 
		return Vector2((global_position.x + 30), global_position.y)
