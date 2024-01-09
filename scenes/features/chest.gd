extends StaticBody2D

signal toggle_inventory(external_inv_owner) 
#the "state" is just to fill the requirements for the function it gets passed into in main

@export var inventory_data: InventoryData

func player_interact() -> void:
	toggle_inventory.emit(self)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.to_string() != "player":
		print_debug("PlayerDetector: detected something that wasn't the player")
		return
	
	$Tooltip.show()


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.to_string() != "player":
		print_debug("PlayerDetector: detected something that wasn't the player")
		return
	
	$Tooltip.hide()
