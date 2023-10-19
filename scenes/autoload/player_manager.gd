extends Node

var player: Player
var main: Node

var UnarmedAnimationList = {
	BaseState.Animations.Reset: "RESET",
	BaseState.Animations.Idle: "unarmed_idle",
	BaseState.Animations.Run: "unarmed_run",
	BaseState.Animations.Attack: "unarmed_attack",
	BaseState.Animations.Attack2: "unarmed_attack"
}

var GauntletAnimationList = {
	BaseState.Animations.Reset: "RESET",
	BaseState.Animations.Idle: "punch_idle",
	BaseState.Animations.Run: "punch_run",
	BaseState.Animations.Attack: "punch_attack",
	BaseState.Animations.Attack2: "punch_attack"
}

var SwordAnimationList = {
	BaseState.Animations.Reset: "RESET",
	BaseState.Animations.Idle: "sword_idle",
	BaseState.Animations.Run: "sword_run",
	BaseState.Animations.Attack: "sword_attack",
	BaseState.Animations.Attack2: "sword_attack"
}

var gauntlet_cooldown: float = 0.3
var sword_cooldown: float = 0.6

var max_armor = 99

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)


func set_equipped_weapon(slot_data):
	if str(slot_data) == "unarmed":
		player.current_weapon = player.unarmed_weapon
		return
		
	elif not slot_data.item_data is ItemDataWeapon:
		print("player_manager: set_equipped_weapon isnt of type ItemDataWeapon")
		
	player.current_weapon = slot_data
	

func set_equipped_armor(slot_data):
	if str(slot_data) == "unarmored":
		player.current_armor = player.unarmored_armor
		return
	elif not slot_data.item_data is ItemDataArmor:
		print("player_manager: set_equipped_armor isnt of type ItemDataArmor")
		
	player.current_armor = slot_data


func player_damaged(amount:float):
	main.update_player_health_bar(amount * -1)
	
	
func player_healed(amount:float):
	main.update_player_health_bar(amount)


func player_max_health_changed(amount):
	main.update_player_max_health(amount)
