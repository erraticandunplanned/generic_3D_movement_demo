extends Node

@export_category("Components")
@export var player : CharacterBody3D
@export var head : Node3D
@export var statistics : StatisticsComponent
@export var grip_left : Node3D
@export var grip_right : Node3D

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(_delta):
	if not is_multiplayer_authority() or Global.paused or Global.menu_open: return

	if Input.is_action_just_pressed("use_active_left"): 
		for action in grip_left.find_children("*","ActiveAbility",false):
			action._on_action_press()
	if Input.is_action_just_pressed("use_active_right"):
		for action in grip_right.find_children("*","ActiveAbility",false):
			action._on_action_press()
