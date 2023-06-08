extends Node

var player: Player

var GauntletAnimationList = {
	BaseState.Animations.Reset: "RESET",
	BaseState.Animations.Idle: "punch_idle",
	BaseState.Animations.Run: "punch_run",
	BaseState.Animations.Attack: "punch_attack",
	BaseState.Animations.Attack2: "punch_attack"
}

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)


func set_equipped_weapon(slot_data: SlotData):
	if not slot_data.item_data is ItemDataWeapon:
		print("player_manager: set_equipped_weapon isnt of type ItemDataWeapon")
	player.current_weapon = slot_data
	player.state_manager.current_weapon = slot_data
