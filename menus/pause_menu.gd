extends Control

@onready var start_menu = $foreground/MarginContainer/CenterContainer/start_menu
@onready var settings_menu = $foreground/MarginContainer/CenterContainer/settings_menu

@onready var first_person_toggle = $foreground/MarginContainer/CenterContainer/settings_menu/MarginContainer/VBoxContainer/MarginContainer/first_person_camera

var player : CharacterBody3D
var statistics : StatisticsComponent

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player = get_parent().get_parent()
	statistics = player.statistics
	swapmenu(0)
	## ENSURE ALL TOGGLES ARE ALLIGNED WITH STATISTICS
	first_person_toggle.button_pressed = statistics.first_person_camera

func swapmenu(menu : int):
	start_menu.visible = true if menu == 0 else false
	settings_menu.visible = true if menu == 1 else false

## MAIN PAUSE MENU

func _on_resume_button_pressed():
	player.swap_to_menu("HUD")
	#Global.paused = false
	#queue_free()

func _on_settings_button_pressed():
	swapmenu(1)

func _on_quit_button_pressed():
	if multiplayer.is_server():
		Global.upnp.delete_port_mapping(Global.PORT)
	get_tree().quit(0)

## SETTINGS MENU

func _on_first_person_camera_toggled(toggled_on):
	statistics.first_person_camera = toggled_on
	
	#if statistics.first_person_camera:
	#	player.camera.position.z = 0
	#else:
	#	player.camera.position.z = 8

func _on_return_button_pressed():
	swapmenu(0)
