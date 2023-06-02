extends Node

@onready var states = {
	BaseState.State.Idle: $Idle,
	BaseState.State.Run: $Run,
	BaseState.State.Fall: $Fall,
	BaseState.State.Jump: $Jump,
	BaseState.State.Attack: $Attack,
	BaseState.State.Attack2: $Attack2
}

var current_state : BaseState
var has_jumped : bool = false


func change_state(new_state: int):
	if current_state:
		has_jumped = current_state.has_jumped
		current_state.exit()
		
	current_state = states[new_state]
	current_state.has_jumped = has_jumped
	current_state.enter()


func init(player : Player):
	for child in get_children():
		child.player = player
	
	# Initialize default state to idle
	change_state(BaseState.State.Idle)
	

func physics_process(delta : float):
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.Null:
		change_state(new_state)
		
	
func input(event : InputEvent):
	var new_state = current_state.input(event)
	if new_state != BaseState.State.Null:
		change_state(new_state)
