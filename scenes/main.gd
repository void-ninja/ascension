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
	
	for i in get_tree().get_nodes_in_group("external_inventory"):
		i.toggle_inventory.connect(toggle_inventory_interface)
	
#region initialize menus

	inventory_interface.visible = false
	pause_menu.visible = false
	death_menu.visible = false
	# main_menu.visible = true #commented out for ease of dev
	
	
#endregion
	# player.can_move = false #commented out for ease of dev
	

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


func toggle_pause_menu() -> void:
	print("pause")
	if main_menu.visible == true or death_menu.visible == true:
		return
	if inventory_interface.visible == true:
		toggle_inventory_interface()
	
	if pause_menu.visible:
		get_tree().paused = false
		blur.visible = false
		pause_menu.visible = false
		player.can_move = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: 
		get_tree().paused = true
		blur.visible = true
		pause_menu.visible = true
		player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func toggle_main_menu() -> void:
	if pause_menu.visible:
		toggle_pause_menu()
	if death_menu.visible:
		toggle_death_menu()
	if inventory_interface.visible:
		toggle_inventory_interface()
	
	if main_menu.visible:
		get_tree().paused = false
		main_menu.visible = false
		player.can_move = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: 
		get_tree().paused = true
		main_menu.visible = true
		player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		reset()


func toggle_inventory_interface(external_inventory_owner = null) -> void:
	if pause_menu.visible or main_menu.visible or death_menu.visible:
		return
		
	close_timer.start()

	if inventory_interface.visible:
		get_tree().paused = false
		blur.visible = false
		inventory_interface.visible = false
		player.can_move = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: 
		get_tree().paused = true
		blur.visible = true
		inventory_interface.visible = true
		player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func toggle_death_menu() -> void:
	if main_menu.visible or pause_menu.visible:
		return
	if inventory_interface.visible:
		toggle_inventory_interface()

	if death_menu.visible:
		get_tree().paused = false
		blur.visible = false
		death_menu.visible = false
		player.can_move = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: 
		get_tree().paused = true
		blur.visible = true
		death_menu.visible = true
		player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func respawn_player() -> void:
	toggle_death_menu()
	player.reset()
	player.position = level_manager.get_player_spawn_pos()


func _on_player_player_died() -> void:
	toggle_death_menu()
