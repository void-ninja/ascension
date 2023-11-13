extends Control
class_name HealthBar

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthLabel

var health:float = 0 : 
		set(value):
			health_bar.value = value
			var string = snappedf(value, 1)
			health_label.text = str(string)
# health stuff here, connect to health component and get the max health, current health
# and damaged signal


func multiply_health_bar_length(multiplier:int):
	health_bar.size.x = health_bar.size.x * multiplier
	health_label.size.x = health_bar.size.x
