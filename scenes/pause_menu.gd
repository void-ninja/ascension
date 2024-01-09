extends Control

signal unpaused
signal quit_button_pressed

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _on_resume_button_button_up() -> void:
	unpaused.emit()


func _on_quit_button_button_up() -> void:
	quit_button_pressed.emit()
