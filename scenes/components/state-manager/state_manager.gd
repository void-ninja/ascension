extends Node

@onready var states = {
	BaseState.State.Idle: $Idle,
	BaseState.State.Run: $Run,
	BaseState.State.Fall: $Fall,
	BaseState.State.Jump: $Jump,
	BaseState.State.Attack: $Attack,
	BaseState.State.Attack2: $Attack2,
	BaseState.State.Knockback: $Knockback
}

var current_state : BaseState
var has_jumped : bool = false
var current_weapon: SlotData
var animation_list: Dictionary




func change_state(new_state: int):
	if current_state:
		has_jumped = current_state.has_jumped
		current_state.exit()
		
	current_state = states[new_state]
	current_state.has_jumped = has_jumped
	current_state.animation_set = animation_list
	if current_state == states[BaseState.State.Attack] or current_state == states[BaseState.State.Attack2]:
		if current_weapon.item_data.type == "Gauntlets":
			current_state.ATTACK_COOLDOWN_MAX = PlayerManager.gauntlet_cooldown
			
		elif current_weapon.item_data.type == "Sword":
			current_state.ATTACK_COOLDOWN_MAX = PlayerManager.sword_cooldown
			
		else:
			# Currently equipped is unarmed
			current_state.ATTACK_COOLDOWN_MAX = PlayerManager.gauntlet_cooldown
			
	current_state.enter()
	

func reset_state():
		# TODO This should just reset the animations.
		current_state.exit()
		current_state.animation_set = animation_list
		current_state.enter()


func init(player : Player):
	for child in get_children():
		child.player = player
	
	player.knockback.connect(_on_player_knockback)
	
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


func set_animation_list():
	if current_weapon:
		if current_weapon.item_data.type == "Gauntlets":
			animation_list = PlayerManager.GauntletAnimationList
		elif current_weapon.item_data.type == "Sword":
			animation_list = PlayerManager.SwordAnimationList
		else:
			animation_list = PlayerManager.UnarmedAnimationList
			# This will be met if no weapon is equipped
	else:
		print("ERR: state_manager func set_animation_list() -> current_weapon == " + str(current_weapon))


func _on_player_knockback(direction,strength):
	change_state(BaseState.State.Knockback)
	current_state.knockback = direction*strength
