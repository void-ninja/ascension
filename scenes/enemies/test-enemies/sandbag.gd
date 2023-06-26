extends CharacterBody2D

func _ready() -> void:
	pass


func _on_hurtbox_component_hit(other_area:Area2D) -> void:
	$DamageDisplay.text = str(other_area.damage)
	$DamageDisplay.show()
	$DamageDisplayTimer.start()


func _on_damage_display_timer_timeout() -> void:
	$DamageDisplay.hide()
