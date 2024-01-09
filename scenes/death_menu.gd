extends Control

signal quit_button_pressed
signal respawn_button_pressed

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _on_respawn_button_button_up() -> void:
	respawn_button_pressed.emit()


func _on_quit_button_button_up() -> void:
	quit_button_pressed.emit()
