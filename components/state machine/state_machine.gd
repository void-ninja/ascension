## Generic state machine. Initializes states and delegates engine callbacks
## (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

## Emitted when transitioning to a new state.
signal transitioned(state_name)

## Path to the initial active state. Exported to be able to pick the initial state in the inspector.
@export var initial_state := NodePath()

## The current active state. At the start, get the [code]initial_state[/code].
@onready var current_state: BaseState = get_node(initial_state)


func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	current_state.enter()


## The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


## This function calls the current state's [code]exit()[/code] function, then changes the active state,
## and calls its enter function.
## It optionally takes a `msg` dictionary to pass to the next state's [code]enter()[/code] function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		print_debug('[Err] - State Machine doesn\'t have node '+target_state_name+' as a child!')
		return

	current_state.exit()
	current_state = get_node(target_state_name)
	current_state.enter(msg)
	transitioned.emit(current_state.name)
