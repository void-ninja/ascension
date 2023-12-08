extends Control

signal unpaused(state)

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	

func _on_start_button_button_up() -> void:
	unpaused.emit(0)


func _on_quit_button_button_up() -> void:
	get_tree().quit()
