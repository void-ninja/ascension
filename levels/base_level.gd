extends Node2D

signal checkpoint_hit(checkpoint) #passes up a reference to the checkpoint that got activated

@onready var player_spawn_pos: Vector2 = $PlayerSpawnPos.position


func _ready() -> void:
	if !player_spawn_pos:
		assert("base_level: player_spawn_pos doesn't exist")


func _on_checkpoint_manager_checkpoint_hit(checkpoint: Variant) -> void:
	checkpoint_hit.emit(checkpoint)


func reset() -> void:
	for i in get_children():
		if i.has_method("reset"):
			i.reset()
