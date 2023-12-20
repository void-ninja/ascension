extends Node2D

@onready var player_spawn_pos: Vector2 = $PlayerSpawnPos.position


func _ready() -> void:
	if !player_spawn_pos:
		assert("base_level: player_spawn_pos doesn't exist")
