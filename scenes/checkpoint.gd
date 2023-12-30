extends Area2D

signal checkpoint_hit(checkpoint)

@onready var flag: Polygon2D = $Flag
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var is_active := false

func _ready() -> void:
	flag.position = Vector2.ZERO
	

func _on_body_entered(body: Node2D) -> void:
	if body.to_string() == "player" and !is_active:
		var tween = create_tween()
		tween.tween_property(flag, "position", Vector2(0,-32), 1)
		gpu_particles_2d.emitting = true
		
		is_active = true
		checkpoint_hit.emit(self)
		

func reset() -> void:
	flag.position = Vector2.ZERO
	is_active = false
	gpu_particles_2d.emitting = false
	
	
