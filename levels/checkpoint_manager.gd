extends Node

signal checkpoint_hit(checkpoint) #passes up a reference to the checkpoint that got activated

func _on_checkpoint_checkpoint_hit(checkpoint: Variant) -> void:
	checkpoint_hit.emit(checkpoint)


func reset():
	for i in get_children():
		i.reset()
