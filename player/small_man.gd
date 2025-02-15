extends CharacterBody3D

@onready var pause_menu = preload("res://menus/pause_menu.tscn")
@onready var inventory_menu = preload("res://menus/inventory.tscn")
@onready var canvas = $CanvasLayer
@onready var statistics : StatisticsComponent = $ComponentDefaultStatistics
@onready var camera = $head/Camera3D

var last_used_spawns

func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		Global.paused = not Global.paused
		if Global.paused:
			var menu = pause_menu.instantiate()
			canvas.add_child(menu)
			menu.name = "pause_menu"
		else:
			for m in canvas.get_children():
				if m.name == "pause_menu": m.queue_free()
	
	if Input.is_action_just_pressed("open_inventory"):
		Global.inventory_open = not Global.inventory_open
		if Global.inventory_open:
			var menu = inventory_menu.instantiate()
			canvas.add_child(menu)
			menu.name = "inventory_menu"
		else:
			for m in canvas.get_children():
				if m.name == "inventory_menu": m.queue_free()

@rpc("any_peer", "call_local")
func place_player(provided_spawn_positions):
	if not is_multiplayer_authority(): return
	if provided_spawn_positions is Dictionary:
		last_used_spawns = provided_spawn_positions
	var spawn_position = last_used_spawns.keys()[randi_range(0, last_used_spawns.size())-1] 
	# todo: nullify already chosen locations ------------------------------------------------------
	set_global_position(spawn_position)
	set_global_rotation(Vector3(0,last_used_spawns[spawn_position],0))
