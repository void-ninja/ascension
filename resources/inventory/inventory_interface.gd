extends Control

signal drop_slot_data(slot_data: SlotData)
signal toggle_inventory

var grabbed_slot_data: SlotData

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var armor_inventory: PanelContainer = $ArmorInventory
@onready var weapon_inventory: PanelContainer = $WeaponInventory

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _physics_process(delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(3, 3)


func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)


func set_armor_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	armor_inventory.set_inventory_data(inventory_data)


func set_weapon_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	weapon_inventory.set_inventory_data(inventory_data)


func on_inventory_interact(inventory_data: InventoryData,
		index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()


func update_grabbed_slot() ->void :
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else: 
		grabbed_slot.hide()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_inventory") and $CloseTimer.is_stopped():
		toggle_inventory.emit()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
		
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
				
		update_grabbed_slot()
	

func _on_visibility_changed() -> void:
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
