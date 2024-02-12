extends Node2D
class_name Level

@onready var player_spawn = $PlayerSpawnPosition
@onready var level_end_component: Area2D = $LevelEndComponent


func unload() -> void:
	queue_free()
