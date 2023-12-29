extends CharacterBody2D
class_name Player

signal paused(state)
signal toggle_inventory(state)
signal main_menu(state)
signal knockback(direction, strength)

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hitbox_component : Area2D = $HitboxComponent
@onready var sprite : Sprite2D = $PlayerSprite
@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var armor_sprite: Sprite2D = $ArmorSprite
@onready var state_manager : Node = $StateManager
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

@export var inventory_data: InventoryData
@export var armor_inventory_data: InventoryDataArmor
@export var weapon_inventory_data: InventoryDataWeapon

@export var unarmed_weapon: SlotData
@export var unarmored_armor: SlotData

@export var move_speed : int = 180
var friction = 0.2
var acceleration = 0.06
var reverse_acceleration = 0.2

var invincibility_seconds = 0.5

var max_health = 10000

var current_weapon: SlotData : 
	set(value):
		current_weapon = value
		hitbox_component.damage = value.item_data.damage
		hitbox_component.knockback_strength = value.item_data.knockback_strength
		if value != null and value.item_data.texture != null:
			if value.item_data.palette:
				weapon_sprite.material.set_shader_parameter("palette", value.item_data.palette)
			else:
				weapon_sprite.material.set_shader_parameter("palette", null)
			state_manager.current_weapon = value
			state_manager.set_animation_list()
			if state_manager.current_state:
				state_manager.reset_state()
		else:
			state_manager.current_weapon = value 
			state_manager.set_animation_list()
			
			weapon_sprite.material.set_shader_parameter("palette", null)
			weapon_sprite.visible = false
			
var current_armor: SlotData :
		set(value):
			current_armor = value
			health_component.armor_value = value.item_data.defense
			if value != null and value.item_data.texture != null:
				armor_sprite.visible = true
				if value.item_data.palette:
					armor_sprite.material.set_shader_parameter("palette", value.item_data.palette)
				else:
					armor_sprite.material.set_shader_parameter("palette", null)
			else: 
				armor_sprite.material.set_shader_parameter("palette", null)
				armor_sprite.visible = false


func _ready():
	PlayerManager.player = self
	hitbox_component.get_node("PunchHitbox").disabled = true
	hitbox_component.get_node("SwordHitbox").disabled = true
	
	hurtbox_component.invincibility_seconds = invincibility_seconds
	
	PlayerManager.set_equipped_armor("unarmored")
	PlayerManager.set_equipped_weapon("unarmed")
	# Initialize the state machine passing a reference to the player
	state_manager.init(self)
	
	await get_parent().ready
	health_component.max_health = max_health
	health_component.heal(max_health)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released("pause"):
		paused.emit(1)
	if Input.is_action_just_pressed("open_inventory"):
		toggle_inventory.emit(1)
	state_manager.input(event)


func _physics_process(delta):
	state_manager.physics_process(delta)


func reset() -> void:
	PlayerManager.player = self
	hitbox_component.get_node("PunchHitbox").disabled = true
	hitbox_component.get_node("SwordHitbox").disabled = true
	
	hurtbox_component.invincibility_seconds = invincibility_seconds
	
	PlayerManager.set_equipped_armor("unarmored")
	PlayerManager.set_equipped_weapon("unarmed")

	health_component.max_health = max_health
	health_component.heal(max_health)


func set_player_orientation(x_direction : float): 
	# Negative values are left, positive are right
	if x_direction < 0 :
		sprite.flip_h = true
		weapon_sprite.flip_h = true
		armor_sprite.flip_h = true
		if hitbox_component.scale.x > 0: # Flip the attack hurtbox to the player orientation
			hitbox_component.scale.x *= -1
	elif x_direction > 0:
		sprite.flip_h = false
		weapon_sprite.flip_h = false
		armor_sprite.flip_h = false
		if hitbox_component.scale.x < 0:
			hitbox_component.scale.x *= -1


func get_drop_position() -> Vector2:
	if sprite.flip_h:
		return Vector2((global_position.x - 30), global_position.y)
	else: 
		return Vector2((global_position.x + 30), global_position.y)


func _on_health_component_damaged(amount:float,current) -> void:
	PlayerManager.player_damaged(amount)


func _on_health_component_healed(amount:float,current) -> void:
	PlayerManager.player_healed(amount)


func _on_health_component_max_health_changed(amount:float) -> void:
	PlayerManager.player_max_health_changed(amount)


func _on_hurtbox_component_knockback(direction, strength) -> void:
	knockback.emit(direction, strength)


func _on_health_component_died() -> void:
	main_menu.emit(1)
	
