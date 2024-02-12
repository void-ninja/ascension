extends Area2D

signal hit


func _on_body_entered(_body: Node2D) -> void: 
	## this should never trigger from anything other than the player, 
	## because of physics layers
	hit.emit()
