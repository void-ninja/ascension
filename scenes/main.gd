extends Node

const PickUp = preload("res://scenes/player/inventory/pick_up.tscn")

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_armor_inventory_data(player.armor_inventory_data)
	inventory_interface.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_inventory_interface_drop_slot_data(slot_data) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
