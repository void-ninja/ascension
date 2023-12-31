extends Control

signal unpaused(state)
signal quit_button_pressed(state)

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _on_resume_button_button_up() -> void:
	unpaused.emit(0)


func _on_quit_button_button_up() -> void:
	quit_button_pressed.emit(1)
