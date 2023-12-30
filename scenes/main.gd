extends Node

const PickUp = preload("res://scenes/player/inventory/pick_up.tscn")

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var close_timer: Timer = $UI/InventoryInterface/CloseTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var effects: Control = $Effects
@onready var blur: TextureRect = $Effects/Blur
@onready var pause_menu: Control = $UI/PauseMenu
@onready var main_menu: Control = $UI/MainMenu
@onready var level_manager: Node = $LevelManager
@onready var death_menu: Control = $UI/DeathMenu


func _ready() -> void:
	player.position = level_manager.player_spawn_pos
	
	PlayerManager.main = self
	
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_armor_inventory_data(player.armor_inventory_data)
	inventory_interface.set_weapon_inventory_data(player.weapon_inventory_data)
	
	toggle_inventory_interface(0)
	toggle_pause_menu(0)
	# toggle_main_menu(1) commented out for ease of dev
	

func reset() -> void:
	level_manager.reset()
	player.reset()
	player.position = level_manager.player_spawn_pos


func _physics_process(delta: float) -> void:
	effects.position.x = camera_2d.get_screen_center_position().x - effects.size.x/2
	effects.position.y = camera_2d.get_screen_center_position().y - effects.size.y/2


func on_inventory_interface_drop_slot_data(slot_data) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	$PickupManager.add_child(pick_up)


func update_player_health_bar(amount:float) -> void:
	$UI/HealthBar.value += amount
	$UI/HealthBar/HealthLabel.text = str($UI/HealthBar.value)


func update_player_max_health(amount:float) -> void:
	$UI/HealthBar.max_value = amount


func toggle_pause_menu(state:int) -> void:
	if main_menu.visible == true or death_menu.visible == true:
		return
	if inventory_interface.visible == true:
		toggle_inventory_interface(0)
	 # 1 = on, 0 = off
	if state > 1 or state < 0:
		assert(false, " main.toggle_pause_menu() : 'state' is out of range")
	
	if state == 1 :
		get_tree().paused = true
		blur.visible = true
		pause_menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: 
		get_tree().paused = false
		blur.visible = false
		pause_menu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func toggle_main_menu(state:int) -> void:
	if pause_menu.visible == true:
		toggle_pause_menu(0)
	if death_menu.visible == true:
		toggle_death_menu(0)
	if inventory_interface.visible == true:
		toggle_inventory_interface(0)
	 # 1 = on, 0 = off
	if state > 1 or state < 0:
		assert(false, " main.toggle_main_menu() : 'state' is out of range")
	
	if state == 1 :
		get_tree().paused = true
		main_menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: 
		get_tree().paused = false
		main_menu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		reset()


func toggle_inventory_interface(state:int) -> void:
	if pause_menu.visible == true or main_menu.visible == true:
		return
	close_timer.start()
	# 1 = on, 0 = off
	if state > 1 or state < 0:
		assert(false, " main.toggle_inventory_interface() : 'state' is out of range")
	
	if state == 1 :
		get_tree().paused = true
		blur.visible = true
		inventory_interface.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: 
		get_tree().paused = false
		blur.visible = false
		inventory_interface.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func toggle_death_menu(state:int) -> void:
	if main_menu.visible == true:
		return
	if inventory_interface.visible == true:
		toggle_inventory_interface(0)
	 # 1 = on, 0 = off
	if state > 1 or state < 0:
		assert(false, " main.toggle_died_menu() : 'state' is out of range")
	
	if state == 1 :
		get_tree().paused = true
		blur.visible = true
		death_menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: 
		get_tree().paused = false
		blur.visible = false
		death_menu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func respawn_player() -> void:
	toggle_death_menu(0)
	player.reset()
	player.position = level_manager.get_player_spawn_pos()


func _on_player_player_died() -> void:
	toggle_death_menu(1)
