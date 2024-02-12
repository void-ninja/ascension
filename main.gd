extends Node

@onready var level_manager: Node = $LevelManager
@onready var player: Player = $Player

func _ready() -> void:
	level_manager.player = player
	level_manager.start()
