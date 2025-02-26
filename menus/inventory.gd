extends Control

#@onready var slots_node = $slots
@onready var accessory_tilemap = $slots/TileMap
@onready var empty_tile = preload("res://textures/inventory/empty_slot.png")

var player : CharacterBody3D
var statistics : StatisticsComponent

#enum {ARMOR, CLOTHING, GEAR, CHARM}

var current_accessory_set = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player = get_parent().get_parent()
	statistics = player.statistics

func _process(delta):
	if Input.is_action_just_pressed("ui_tab_left"): change_accessory_set(-1)
	if Input.is_action_just_pressed("ui_tab_right"): change_accessory_set(1)

func change_accessory_set(dir : int):
	current_accessory_set += dir
	if current_accessory_set > 3: current_accessory_set = 0
	if current_accessory_set < 0: current_accessory_set = 3
	
	print("current set: ", current_accessory_set)
	var pattern = accessory_tilemap.tile_set.get_pattern(current_accessory_set)
	accessory_tilemap.set_pattern(1, Vector2i(2,4),pattern)
