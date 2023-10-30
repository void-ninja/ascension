extends Node
class_name BaseState

enum State {
	Null,
	Idle,
	Run,
	Fall,
	Jump,
	Attack,
	Attack2,
	Knockback
}

enum Animations {
	Reset,
	Idle,
	Run,
	Attack,
	Attack2,
	Launch,
	Fly,
	Invert,
	Fall,
	Landing
}

var animation_name : String

var player : Player = null
var has_jumped : bool = false
var animation_set : Dictionary

func enter() -> void:
	player.animation_player.play(animation_name)


func exit() -> void:
	pass


# Enums are internally stored as ints, so that is the expected return type
func input(event : InputEvent) -> int:
	return State.Null


func process(delta) -> int:
	return State.Null
	

func physics_process(delta) -> int:
	return State.Null
