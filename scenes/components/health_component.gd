extends Node
class_name HealthComponent

signal died
signal damaged(float)
signal healed(float)
signal max_health_changed(float)

@export var max_health: float = 100 :
		set(value):
			max_health = value
			max_health_changed.emit(value)
			
var current_health: float

func _ready():
	current_health = max_health


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	damaged.emit(damage_amount)
	if current_health == 0:
		died.emit()
		owner.queue_free()


func heal(heal_amount: float):
	current_health = min(current_health + heal_amount, max_health)
	healed.emit(heal_amount)
