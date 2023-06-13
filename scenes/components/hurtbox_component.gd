extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var texture: Sprite2D

signal hit(other_area: Area2D)


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
		
	hit.emit(other_area)
	
	if health_component == null:
		return
		
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	
	if texture != null: flash()
	

func flash() -> void:
	texture.material.set_shader_parameter("flash_modifier", 0.90)
	$FlashTimer.start()
	
	
func _on_flash_timer_timeout() -> void:
	texture.material.set_shader_parameter("flash_modifier", 0)
