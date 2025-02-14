extends CharacterBody3D

var last_used_spawns

@rpc("any_peer", "call_local")
func place_player(provided_spawn_positions):
	if not is_multiplayer_authority(): return
	if provided_spawn_positions is Dictionary:
		last_used_spawns = provided_spawn_positions
	var spawn_position = last_used_spawns.keys()[randi_range(0, last_used_spawns.size())-1] 
	# todo: nullify already chosen locations ------------------------------------------------------
	set_global_position(spawn_position)
	set_global_rotation(Vector3(0,last_used_spawns[spawn_position],0))
