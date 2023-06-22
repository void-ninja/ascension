extends Node

const PickUp = preload("res://scenes/player/inventory/pick_up.tscn")

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var close_timer: Timer = $UI/InventoryInterface/CloseTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var effects: Control = $Effects
@onready var blur: TextureRect = $Effects/Blur


func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.drop_slot_data.connect(on_inventory_interface_drop_slot_data)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_armor_inventory_data(player.armor_inventory_data)
	inventory_interface.set_weapon_inventory_data(player.weapon_inventory_data)
	inventory_interface.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	effects.position.x = camera_2d.get_screen_center_position().x - effects.size.x/2
	effects.position.y = camera_2d.get_screen_center_position().y - effects.size.y/2
	

func toggle_inventory_interface() -> void:
	close_timer.start()
	blur.visible = not blur.visible
	inventory_interface.visible = not inventory_interface.visible
	get_tree().paused = not get_tree().paused
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func on_inventory_interface_drop_slot_data(slot_data) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
