extends ItemData
class_name ItemDataConsumable

@export var heal_amount: int

func use(target) -> void:
	if heal_amount != 0:
		target.health_component.heal(heal_amount)
