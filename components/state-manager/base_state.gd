extends Node
class_name BaseState

enum State {
	Null,
	Idle,
	Run,
	Fall,
	Jump,
	Attack
}

@export var animation_name : String

var player : Player

func enter() -> void:
	player.animation_player.play(animation_name)


func exit() -> void:
	pass


# Enums are internally stored as ints, so that is the expected return type
func input(event : InputEvent) -> int:
	return State.Null


func process(delta : float) -> int:
	return State.Null
	

func physics_process(delta : float) -> int:
	return State.Null
