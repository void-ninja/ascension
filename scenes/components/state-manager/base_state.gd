extends Node
class_name BaseState

enum State {
	Null,
	Idle,
	Run,
	Fall,
	Jump,
	Attack,
	Attack2
}

enum Animations {
	Reset,
	Idle,
	Run,
	Attack,
	Attack2
}

var animation_name : String

var player : Player = null
var has_jumped : bool = false
var current_knockback : Vector2 = Vector2.ZERO
var animation_set : Dictionary

func enter() -> void:
	player.knockback.connect(_on_player_knockback)
	player.animation_player.play(animation_name)


func exit() -> void:
	player.knockback.disconnect(_on_player_knockback)


# Enums are internally stored as ints, so that is the expected return type
func input(event : InputEvent) -> int:
	return State.Null


func process(delta) -> int:
	return State.Null
	

func physics_process(delta) -> int:
	return State.Null


func _on_player_knockback(direction, strength):
	current_knockback = direction * strength
