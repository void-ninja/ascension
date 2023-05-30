extends Node

@onready var states = {
	BaseState.State.Idle: $Idle,
	BaseState.State.Run: $Run,
	BaseState.State.Fall: $Fall,
	BaseState.State.Jump: $Jump,
	BaseState.State.Attack: $Attack
}

var current_state : BaseState

func change_state(new_state: int):
	if current_state:
		current_state.exit()
		
	current_state = states[new_state]
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
