extends Control

@onready var selection_node  : TileMapLayer = $slotmap_64/selection
@onready var item_node             : Node2D = $slotmap_64/items
@onready var selection_wheel_node : Control = $CenterContainer/selection_wheel
@onready var armament_left_slot  : Sprite2D = $slotmap_64/armament_left
@onready var armament_right_slot : Sprite2D = $slotmap_64/armament_right
@onready var item_texture_node = preload("res://items_and_materials/inventory_item_texture.tscn")
@onready var selection_wheel = preload("res://menus/generic_selection_wheel.tscn")
@onready var item_texture_path = "res://textures/item_images/"

var player     : CharacterBody3D
var statistics : StatisticsComponent
var inventory  : InventoryComponent
var grip_left  : Node3D
var grip_right : Node3D
var hotbar     : Node3D

const selection_atlas_coord = Vector2i(1,0)
const hotbar_index_map = [Vector2i(-6,7),Vector2i(-5,7),Vector2i(-4,7),Vector2i(-3,7),Vector2i(-2,7),Vector2i(-1,7),Vector2i(0,7),Vector2i(1,7),Vector2i(2,7),Vector2i(3,7),Vector2i(4,7),Vector2i(5,7)]
#const hotbar_index_loc = [Vector2(-448,960),Vector2(-320,960),Vector2(-192,960),Vector2(-64,960),Vector2(64,960),Vector2(192,960),Vector2(320,960),Vector2(448,960)]
var hotbar_node_index = []

var selecting_weapon = false
var wheel_open = false
var selecting_weapon_timer = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent().get_parent().get_parent()
	statistics = player.statistics
	inventory = player.find_child("ComponentGearAndInventory", false)
	var hands : Node3D = player.find_child("hands")
	grip_left = hands.get_child(0)
	grip_right = hands.get_child(1)
	hotbar = hands.get_child(2)
	
	## SET HOTBAR
	hotbar_node_index.resize(inventory.inv_slots.size())
	for i in range(0,inventory.hotbar_width):
		var check_item : BasicItem = inventory.inv_slots[inventory.active_hotbar_start + i]
		var new_item = item_texture_node.instantiate()
		item_node.add_child(new_item)
		new_item.position = selection_node.map_to_local(hotbar_index_map[i])
		new_item.name = "INV_"+str(i)
		hotbar_node_index[i] = new_item
		if check_item.item_id != "":
			new_item.get_child(0).texture = load(item_texture_path + "sm_" + check_item.item_id + ".png")
			new_item.get_child(1).text = str(check_item.quantity)
		else:
			new_item.get_child(0).texture = null
			new_item.get_child(1).text = ""
	## SET ACTIVE SLOT
	selection_node.clear()
	selection_node.set_cell(hotbar_index_map[inventory.active_hotbar_item],0,selection_atlas_coord)
	
	set_armaments()

func _process(delta):
	## RELEASE SELECTION WHEEL
	if wheel_open:
		if Input.is_action_just_released("weapon_select_L"): set_new_armament_from_wheel(true)
		elif Input.is_action_just_released("weapon_select_R"): set_new_armament_from_wheel(false)
		else: return
	
	## CYCLE ACTIVE HOTBAR SLOT
	if Input.is_action_just_released("hotbar_select_L") and not selecting_weapon and not wheel_open: update_hotbar_selection(-1)
	if Input.is_action_just_released("hotbar_select_R") and not selecting_weapon and not wheel_open: update_hotbar_selection(1)
	if Input.is_action_just_pressed("hotbar_01"): update_hotbar_selection(0, false)
	if Input.is_action_just_pressed("hotbar_02"): update_hotbar_selection(1, false)
	if Input.is_action_just_pressed("hotbar_03"): update_hotbar_selection(2, false)
	if Input.is_action_just_pressed("hotbar_04"): update_hotbar_selection(3, false)
	if Input.is_action_just_pressed("hotbar_05"): update_hotbar_selection(4, false)
	if Input.is_action_just_pressed("hotbar_06"): update_hotbar_selection(5, false)
	if Input.is_action_just_pressed("hotbar_07"): update_hotbar_selection(6, false)
	if Input.is_action_just_pressed("hotbar_08"): update_hotbar_selection(7, false)
	if Input.is_action_just_pressed("hotbar_09"): update_hotbar_selection(8, false)
	if Input.is_action_just_pressed("hotbar_10"): update_hotbar_selection(9, false)
	if Input.is_action_just_pressed("hotbar_11"): update_hotbar_selection(10, false)
	if Input.is_action_just_pressed("hotbar_12"): update_hotbar_selection(11, false)
	
	## SELECT WEAPON
	if Input.is_action_pressed("weapon_select_L") or Input.is_action_pressed("weapon_select_R"):
		selecting_weapon_timer += delta
		selecting_weapon = true if selecting_weapon_timer > statistics.HOLD_BUTTON_TIME_THRESHOLD else false
		if not wheel_open and selecting_weapon and Input.is_action_pressed("weapon_select_L"): open_weapon_selection_wheel(true)
		if not wheel_open and selecting_weapon and Input.is_action_pressed("weapon_select_R"): open_weapon_selection_wheel(false)
	else:
		selecting_weapon = false
		selecting_weapon_timer = 0.0
	
	## CYCLE HOTBAR
	if Input.is_action_just_pressed("cycle_hotbar"):
		inventory.active_hotbar_start += 8
		if (inventory.active_hotbar_start + 7) > inventory.inv_slots.size(): inventory.active_hotbar_start = 0
		
		for i in range(0,inventory.hotbar_width):
			var check_item : BasicItem = inventory.inv_slots[inventory.active_hotbar_start + i]
			var slot_item = hotbar_node_index[i]
			if check_item.item_id != "":
				slot_item.get_child(0).texture = load(item_texture_path + "sm_" + check_item.item_id + ".png")
				slot_item.get_child(1).text = str(check_item.quantity)
			else:
				slot_item.get_child(0).texture = null
				slot_item.get_child(1).text = ""
		
		update_hotbar_selection(inventory.active_hotbar_item, false)

func update_hotbar_selection(amt : int, add : bool = true):
	## SELECTION CAN BE "ADDED" WHERE SELECTION IS MODIFIED BY +1 OR -1
	if add:
		inventory.active_hotbar_item += amt
		inventory.active_hotbar_item = 0 if inventory.active_hotbar_item > inventory.hotbar_width else inventory.hotbar_width if inventory.active_hotbar_item < 0 else inventory.active_hotbar_item
	## SELECTION CAN BE "SET" BY SIMPLY SELECTING A SPECIFIC SLOT NUMBER
	else:
		inventory.active_hotbar_item = amt
	selection_node.clear()
	selection_node.set_cell(hotbar_index_map[inventory.active_hotbar_item],0,selection_atlas_coord)
	
	## ADD HOTBAR SCRIPT TO HOTBAR NODE
	## this allows whatever hotbar item is selected to be "used" when the [use hotbar item] key is pressed
	var script_path = inventory.inv_slots[inventory.active_hotbar_start + inventory.active_hotbar_item].hotbar_script_path
	if script_path != "":
		var new_hotbar_script : Script = load(script_path)
		hotbar.set_script(new_hotbar_script)
		hotbar._ready()
	else:
		hotbar.set_script(null)

func open_weapon_selection_wheel(left : bool):
	wheel_open = true
	var new_wheel = selection_wheel.instantiate()
	selection_wheel_node.add_child(new_wheel)
	
	var selection_texture_array : Array[String] = []
	selection_texture_array.resize(4)
	for i in range(4):
		if left and inventory.inv_armaments[i].item_id != "":
			selection_texture_array[i] = item_texture_path + "lg_" + inventory.inv_armaments[i].item_id + ".png" 
		elif not left and inventory.inv_armaments[i+4].item_id != "":
			selection_texture_array[i] = item_texture_path + "lg_" + inventory.inv_armaments[i+4].item_id + ".png" 
		else:
			selection_texture_array[i] = ""
	
	new_wheel.selection = inventory.active_armament_left if left else inventory.active_armament_right
	new_wheel.generate_wheel(selection_texture_array)

func set_new_armament_from_wheel(left : bool):
	var get_weapon = selection_wheel_node.get_child(0).selection
	for i in selection_wheel_node.get_children(): i.queue_free()
	wheel_open = false
	if get_weapon == -1: return
	if left:
		inventory.active_armament_left = get_weapon if get_weapon <= 4 else 0
	else:
		inventory.active_armament_right = get_weapon if get_weapon <= 4 else 0
	set_armaments()

func set_armaments():
	## SET ARMAMENT TEXTURES
	var left_armament : BasicItem = inventory.inv_armaments[inventory.active_armament_left]
	if left_armament.item_id != "":
		armament_left_slot.texture = load(item_texture_path + "sm_" + left_armament.item_id + ".png")
	else:
		armament_left_slot.texture = null
	var right_armament : BasicItem = inventory.inv_armaments[4 + inventory.active_armament_right]
	if right_armament.item_id != "":
		armament_right_slot.texture = load(item_texture_path + "sm_" + right_armament.item_id + ".png")
	else:
		armament_right_slot.texture = null
	
	## SET ARMAMENTS IN PLAYER'S HAND TO ACTIVATE
	if left_armament.armament_script_path != "":
		var new_ability_script : Script = load(left_armament.armament_script_path)
		grip_left.set_script(new_ability_script)
		grip_left._ready()
	else: grip_left.set_script(null)
	if right_armament.armament_script_path != "":
		var new_ability_script : Script = load(right_armament.armament_script_path)
		grip_right.set_script(new_ability_script)
		grip_right._ready()
	else: grip_right.set_script(null)
