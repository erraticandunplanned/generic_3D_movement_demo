extends Control

@onready var start_menu = $foreground/MarginContainer/CenterContainer/start_menu
@onready var play_menu = $foreground/MarginContainer/CenterContainer/play_menu
@onready var multiplayer_menu = $foreground/MarginContainer/CenterContainer/multiplayer_menu
@onready var settings_menu = $foreground/MarginContainer/CenterContainer/settings_menu
@onready var address_bar = $foreground/MarginContainer/CenterContainer/multiplayer_menu/MarginContainer/VBoxContainer/addressEntry

enum {START, PLAY, MULTIPLAYER, SETTINGS}

@onready var administrator = preload("res://menus/the_administrator.tscn")

func _ready():
	swap_menu(START)

func swap_menu(menu : int):
	start_menu.visible = true if menu == 0 else false
	play_menu.visible = true if menu == 1 else false
	multiplayer_menu.visible = true if menu == 2 else false
	settings_menu.visible = true if menu == 3 else false

func game_start(type : int = 0, address : String = "localhost"):
	# type: 0 = singleplayer, 1 = host, 2 = client
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var admin = administrator.instantiate()
	get_tree().root.add_child(admin)
	if type < 2:
		var is_multiplayer = false if type == 0 else true
		admin.begin_game(is_multiplayer)
	else:
		admin.join_game(address)
	self.queue_free()

		##################
		## MENU BUTTONS ##
		##################

## TITLE MENU

func _on_play_button_pressed():
	swap_menu(PLAY)

func _on_settings_button_pressed():
	swap_menu(SETTINGS)

func _on_quit_button_pressed():
	if multiplayer.is_server():
		Global.upnp.delete_port_mapping(Global.PORT)
	get_tree().quit(0)

## PLAY MENU

func _on_single_button_pressed():
	game_start(0)

func _on_multi_button_pressed():
	swap_menu(MULTIPLAYER)

func _on_to_main_pressed():
	swap_menu(START)

## MULTIPLAYER MENU

func _on_host_button_pressed():
	game_start(1)

func _on_join_button_pressed():
	var address = address_bar.text if address_bar.text != "" else "localhost"
	game_start(2, address)

func _on_to_play_pressed():
	swap_menu(PLAY)
