extends Node

var player: Player


func start() -> void:
	var level = Globals.LEVELS[0].instantiate()
	add_child(level)
	player.global_position = level.player_spawn.global_position
	


func next_level() -> void:
	pass
