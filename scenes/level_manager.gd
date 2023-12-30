extends Node

var player_spawn_pos: Vector2
var current_checkpoint

const CHECKPOINT_SPAWN_OFFSET := -20 #because the player spawns inside of the floor

func _ready() -> void:
	if get_child_count() > 1:
		assert("level_manager: get_child_count is greater than one!")
	else:
		for i in get_children():
			player_spawn_pos = i.player_spawn_pos
			i.connect("checkpoint_hit", on_level_checkpoint_hit)
			

func reset() -> void:
	current_checkpoint = null
	for i in get_children():
		i.reset()


func on_level_checkpoint_hit(checkpoint):
	current_checkpoint = checkpoint
	
	
func get_player_spawn_pos():
	if current_checkpoint:
		return current_checkpoint.global_position + Vector2(0,CHECKPOINT_SPAWN_OFFSET)
	else:
		return player_spawn_pos
