extends Node

var player_spawn_pos: Vector2

func _ready() -> void:
	if get_child_count() > 1:
		assert("level_manager: get_child_count is greater than one!")
	else:
		for i in get_children():
			player_spawn_pos = i.player_spawn_pos
