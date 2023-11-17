extends Control

signal unpaused

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _on_resume_button_button_up() -> void:
	unpaused.emit()


func _on_quit_button_button_up() -> void:
	get_tree().quit()
