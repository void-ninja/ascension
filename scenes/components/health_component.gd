extends Node
class_name HealthComponent

signal died
signal damaged(amount,current)
signal healed(amount,current)
signal max_health_changed(float)

var max_health: float = 100 :
		set(value):
			max_health = value
			max_health_changed.emit(value)
			
var current_health: float

var armor_value : float = 0

func _ready():
	await get_parent().ready
	current_health = max_health
	if not get_parent() is Player:
		healed.emit(0,current_health)


func damage(damage_amount: float):
	if armor_value > 0:
		damage_amount -= damage_amount * (armor_value/PlayerManager.MAX_ARMOR)
		current_health = max(current_health - damage_amount, 0)
	else:
		current_health = max(current_health - damage_amount, 0)
	damaged.emit(damage_amount, current_health)
	if current_health == 0:
		died.emit()
		owner.queue_free()


func heal(heal_amount: float):
	current_health = min(current_health + heal_amount, max_health)
	healed.emit(heal_amount, current_health)
