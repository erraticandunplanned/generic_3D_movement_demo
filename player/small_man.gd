extends CharacterBody3D

@onready var pausemenu = preload("res://menus/pause_menu.tscn")
@onready var canvas = $CanvasLayer

var last_used_spawns

func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		Global.paused = not Global.paused
		if Global.paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			var menu = pausemenu.instantiate()
			canvas.add_child(menu)
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			for c in canvas.get_children():
				c.queue_free()

@rpc("any_peer", "call_local")
func place_player(provided_spawn_positions):
	if not is_multiplayer_authority(): return
	if provided_spawn_positions is Dictionary:
		last_used_spawns = provided_spawn_positions
	var spawn_position = last_used_spawns.keys()[randi_range(0, last_used_spawns.size())-1] 
	# todo: nullify already chosen locations ------------------------------------------------------
	set_global_position(spawn_position)
	set_global_rotation(Vector3(0,last_used_spawns[spawn_position],0))
