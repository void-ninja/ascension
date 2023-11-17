extends PanelContainer

const Slot = preload("res://scenes/player/inventory/slot.tscn")

@onready var slot_spot = $MarginContainer

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item)
	populate_item(inventory_data)


func populate_item(inventory_data: InventoryData) -> void:
	for child in slot_spot.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		slot_spot.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
			slot.show_slot_texture()
			PlayerManager.set_equipped_armor(slot_data)
		else: PlayerManager.set_equipped_armor("unarmored")
		
