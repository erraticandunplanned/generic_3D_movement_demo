extends Node2D

## NODE PATH
@onready var item_sprite = $Sprite2D

## THE STATISTICS (TM)
@export_category("Generic Statistics")
@export var quantity : int = 1
@export var item_texture2D : Texture2D
@export_group("Name")
@export var item_id : String
@export var item_name : String
@export_multiline var item_description : String
#@export_group("Typing")
#@export var supertype : String
#@export var type : String
#@export var subtype : String
#@export_group("Materials")
#@export var materials : Array[String]

func get_item() -> Dictionary:
	var item = {
		## GENERIC STATS
		"quantity": 1,
		# Name
		"item_id" : item_id,
		"item_name" : item_name,
		"item_description" : item_description,
		# Typing
		#"supertype" : supertype,
		#"type" : type,
		#"subtype" : subtype,
		# Materials
		#"materials" : materials,
	}
	return item

func set_item(input : Dictionary):
	quantity = input.get("quantity")
	item_id = input.get("item_id")
	item_name = input.get("item_name")
	item_description = input.get("item_description")

### [1] ###
# https://www.youtube.com/playlist?list=PL8VGDn5bxwDa8sAB-bz_l6aJbT_SnHrID
