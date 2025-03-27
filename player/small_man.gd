extends CharacterBody3D

@onready var pause_menu = preload("res://menus/pause_menu.tscn")
@onready var inventory_menu = preload("res://menus/inventory.tscn")
@onready var HUD = preload("res://menus/HUD.tscn")

@onready var canvas = $CanvasLayer/CenterContainer
@onready var statistics : StatisticsComponent = $ComponentDefaultStatistics
@onready var healthbar : HealthComponent = $ComponentHealthbar
@onready var camera_1st = $head/eye_camera
@onready var camera_3rd = $shoulder_pivot/SpringArm3D/shoulder_camera

var last_used_spawns
var time_since_wanderer_press = 0

func _ready():
	var inventory_node = $ComponentGearAndInventory
	inventory_node.set_default_inventory()
	swap_to_menu("HUD")

func _process(_delta):
	if Input.is_action_just_pressed("pause_game"): swap_to_menu("pause_menu")
	if Input.is_action_just_pressed("open_inventory"): swap_to_menu("inventory_menu")
	if Global.menu_open: return
	
	if Input.is_action_just_pressed("interact"):
		var new_attack = AttackClass.new()
		new_attack.amount = 10
		healthbar.recieve_damage(new_attack)
		
		#statistics.first_person_camera = !statistics.first_person_camera
		#if statistics.first_person_camera:
		#	CameraTransition.swap_camera(camera_3rd,camera_1st)
		#else:
		#	CameraTransition.swap_camera(camera_1st,camera_3rd)

func swap_to_menu(request_menu : String = "HUD"):
	var menu_name = request_menu
	for m in canvas.get_children():
		if m.name == request_menu: menu_name = "HUD"
		m.queue_free()
	Global.menu_open = false if menu_name == "HUD" else true # false if menu_name == "selection_wheel" else true
	var new_menu : Node = pause_menu.instantiate() if menu_name == "pause_menu" else inventory_menu.instantiate() if menu_name == "inventory_menu" else HUD.instantiate()
	canvas.add_child(new_menu)
	new_menu.name = menu_name

@rpc("any_peer", "call_local")
func place_player(provided_spawn_positions):
	if not is_multiplayer_authority(): return
	if provided_spawn_positions is Dictionary:
		last_used_spawns = provided_spawn_positions
	var spawn_position = last_used_spawns.keys()[randi_range(0, last_used_spawns.size())-1] 
	# todo: nullify already chosen locations ------------------------------------------------------
	set_global_position(spawn_position)
	set_global_rotation(Vector3(0,last_used_spawns[spawn_position],0))
