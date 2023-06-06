extends RigidBody2D

@export var slot_data: SlotData

@onready var sprite_2d: Sprite2D = $Sprite2D

var counter: int = 10
const DISPLACEMENT_AMOUNT: float = 3

func _ready() -> void:
	sprite_2d.texture = slot_data.item_data.texture


func _physics_process(delta: float) -> void:
	pass # Animate at some point
		
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()


func _on_item_collider_area_entered(area: Area2D) -> void:
	var direction = Vector2((area.global_position.x - self.global_position.x), 0)
	direction = direction.normalized()
	if direction.x == 0:
		direction.x = 1
	global_position -= direction * DISPLACEMENT_AMOUNT
