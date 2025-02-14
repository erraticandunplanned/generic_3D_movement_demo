extends Node3D

@onready var players_node = $players
@onready var world_node = $world

@onready var demo_world = preload("res://levels/demo_world.tscn")
@onready var little_guy = preload("res://player/small_man.tscn")
@onready var octagon_map = preload("res://levels/octogon/octogon_map.tscn")

var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	multiplayer.peer_disconnected.connect(remove_player)
	spawn_world()

		###########################
		## MULTIPLAYER CHICANERY ##
		###########################

func begin_game(multiplayer_game : bool = false):
	#change_to_game_display()
	enet_peer.create_server(Global.PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	var player = add_player(multiplayer.get_unique_id())

	## HOST ONLY
	if multiplayer_game:
		var discovery_result = Global.upnp.discover()
		assert(discovery_result == UPNP.UPNP_RESULT_SUCCESS, \
			"UPNP discover failed! error %s" % discovery_result)
		assert(Global.upnp.get_gateway() and Global.upnp.get_gateway().is_valid_gateway(), \
			"UPNP invalid gateway!")
		var map_result = Global.upnp.add_port_mapping(Global.PORT, 0, "bean arena")
		assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
			"UPNP port mapping failed! error %s" % map_result)
		get_window().title = "join with: %s" % Global.upnp.query_external_address()

func join_game(address):
	#change_to_game_display()
	enet_peer.create_client(address, Global.PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	print("player connected (id: " + str(peer_id), ")")
	var player = little_guy.instantiate()
	player.name = str(peer_id)
	players_node.add_child(player)
	player.position = Vector3(100,1,0)
	if player.is_multiplayer_authority():
		#player.health_changed.connect(update_health_bar) #comment out when using small_man---------------------------------------------
		return player

func remove_player(peer_id):
	print("player disconnected (id: " + str(peer_id), ")")
	var player = get_node(str(peer_id))
	remove_child(player)

		####################
		## GENERATE WORLD ##
		####################

func spawn_world():
	var world1 = octagon_map.instantiate()
	var world2 = demo_world.instantiate()
	world_node.add_child(world1)
	world_node.add_child(world2)
