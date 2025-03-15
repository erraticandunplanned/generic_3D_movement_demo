extends Node

@export_category("Components")
@export var player : CharacterBody3D
@export var head : Node3D
@export var statistics : StatisticsComponent
@export var inventory : InventoryComponent
@export var grip_left : Node3D
@export var grip_right : Node3D

@onready var selection_wheel = preload("res://menus/generic_selection_wheel.tscn")

var canvas : CenterContainer

var selecting_ability = false
var selecting_ability_timer = 0.0
const selecting_ability_threshold = 0.2
var the_wheel_itself : CanvasItem

func _ready():
	canvas = player.find_child("CanvasLayer", false).get_child(0)

func _process(delta):
	if not is_multiplayer_authority() or Global.paused: return
	
	## OPEN WANDERER ABILITY WHEEL
	if Input.is_action_just_pressed("wanderer_ability"):
		the_wheel_itself = selection_wheel.instantiate()
		canvas.add_child(the_wheel_itself)
		#var abilities = ["blank","blank","blank","blank","blank","blank","blank","blank"]
		the_wheel_itself.generate_wheel([],8)
		the_wheel_itself.selection = statistics.wanderer_ability_last_used
		the_wheel_itself.visible = false
	## REVEAL WHEEL AFTER A SMALL DELAY
	if Input.is_action_pressed("wanderer_ability"):
		selecting_ability_timer += delta
		if selecting_ability_timer > selecting_ability_threshold:
			the_wheel_itself.visible = true
	else:
		selecting_ability_timer = 0.0
	## CLOSE WHEEL AND ACTIVATE ABILITY
	if Input.is_action_just_released("wanderer_ability"): 
		var get_ability = the_wheel_itself.selection
		the_wheel_itself.queue_free()
		the_wheel_itself = null
		activate_wanderer_ability(get_ability)
		statistics.wanderer_ability_last_used = get_ability
	
	if Global.menu_open: return
	
	## ACTIVATE ARMAMENTS
	if Input.is_action_just_pressed("use_active_left"):
		#var active_armament = inventory.inv_armaments[inventory.active_armament_left]
		for action in grip_left.get_children():
			action._on_action_press()
	if Input.is_action_just_pressed("use_active_right"):
		#var active_armament = inventory.inv_armaments[4 + inventory.active_armament_right]
		for action in grip_right.get_children():
			action._on_action_press()

#func _physics_process(_delta):
#	if not is_multiplayer_authority() or Global.paused or Global.menu_open: return
#
#	if Input.is_action_just_pressed("use_active_left"): 
#		for action in grip_left.find_children("*","ActiveAbility",false):
#			action._on_action_press()
#	if Input.is_action_just_pressed("use_active_right"):
#		for action in grip_right.find_children("*","ActiveAbility",false):
#			action._on_action_press()

func activate_wanderer_ability(index : int):
	print("use ability ", index)
	pass
