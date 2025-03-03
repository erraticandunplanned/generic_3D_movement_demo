extends Node2D
class_name InventoryItem

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
#@export_category("Weapon Statistics")
#@export var is_weapon : bool = false
#@export_group("Range")
#@export var min_reach : int = 0
#@export var max_reach : int = 1
#@export var min_range : int = 0
#@export var max_range : int = 6
#@export var thrown_range : int = 2

func _ready():
	pass
	#item_sprite.texture = item_texture2D

func _process(delta):
	pass

func get_item() -> Dictionary:
	var item = {
		## GENERIC STATS
		"quantity": 1,
		"item_texture2D" : item_texture2D,
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
		## WEAPON STATS
		#"is_weapon" : is_weapon,
		# Range
		#"min_reach" : min_reach,
		#"max_reach" : max_reach,
		#"min_range" : min_range,
		#"max_range" : max_range,
		#"thrown_range" : thrown_range,
	}
	return item

func set_item(input : Dictionary):
	pass

### [1] ###
# https://www.youtube.com/playlist?list=PL8VGDn5bxwDa8sAB-bz_l6aJbT_SnHrID
