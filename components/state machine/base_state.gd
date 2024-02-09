## Virtual base class for all states.
class_name BaseState
extends Node

## Reference to the state machine, to call its [code]transition_to()[/code] method directly.
## That's one unorthodox detail of our state implementation, as it adds a dependency between the
## state and the state machine objects, but we found it to be most efficient for our needs.
## The state machine node will set it.
var state_machine = null


## Virtual function. Receives events from the [code]_unhandled_input()[/code] callback.
func handle_input(_event: InputEvent) -> void:
	pass


## Virtual function. Corresponds to the [code]_process()[/code] callback.
func update(_delta: float) -> void:
	pass


## Virtual function. Corresponds to the [code]_physics_process()[/code] callback.
func physics_update(_delta: float) -> void:
	pass


## Virtual function. Called by the state machine upon changing the active state. The [param msg] parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
