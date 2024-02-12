class_name Player
extends CharacterBody2D

var speed = 375
var air_speed = 380
var jump_force = -1000

var jump_max_len = 0.25 ## in seconds
var coyote_time_len = 0.1 ## in seconds
var jump_buffer_len = 0.1 ## in seconds

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')
var jump_gravity = gravity / 2
var fast_fall_gravity = gravity * 3

var max_fall_speed = 1800

func get_x_direction() -> float:
	var direction: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	return direction
