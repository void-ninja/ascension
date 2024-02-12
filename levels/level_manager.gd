extends Node

var player: Player
var current_level_index: int
var current_level: Level

func start() -> void:
	current_level_index = 0
	
	current_level = Globals.LEVELS[current_level_index].instantiate()
	add_child(current_level)
	
	current_level.level_end_component.hit.connect(load_next_level)
	player.global_position = current_level.player_spawn.global_position
	

func load_next_level() -> void:
	call_deferred('deferred_load_next_level')


func deferred_load_next_level() -> void:
	current_level.unload()
	
	current_level_index += 1
		
	if current_level_index > len(Globals.LEVELS) - 1: # - 1 for zero-based indexing
		current_level_index = 0
	current_level = Globals.LEVELS[current_level_index].instantiate()
	add_child(current_level)
	
	current_level.level_end_component.hit.connect(load_next_level)
	player.global_position = current_level.player_spawn.global_position
