extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var texture: Sprite2D

#  invincibility timer amount
var invincibility_seconds : float = 0.1


signal hit(other_area: Area2D)
signal knockback(direction: Vector2, strength: int)


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	$InvincibilityTimer.wait_time = invincibility_seconds
	
	if not other_area is HitboxComponent:
		return
		
	hit.emit(other_area)
	
	if health_component == null:
		return
	
	# damage the health component
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	
	# calculate knockback direction and emit a signal with that and the kb power
	var knockback_direction = (global_position - hitbox_component.global_position).normalized()
	knockback.emit(knockback_direction, hitbox_component.knockback_strength)
	
	if texture != null: flash()
	
	if invincibility_seconds > 0:
		area_entered.disconnect(on_area_entered)
		$InvincibilityTimer.start()
		await $InvincibilityTimer.timeout
		area_entered.connect(on_area_entered)
		
	if has_overlapping_areas() and $InvincibilityTimer.is_stopped():
		on_area_entered(get_overlapping_areas()[0])
	

func flash() -> void:
	texture.material.set_shader_parameter("flash_modifier", 0.90)
	$FlashTimer.start()
	
	
func _on_flash_timer_timeout() -> void:
	texture.material.set_shader_parameter("flash_modifier", 0)
