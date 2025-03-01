extends Node2D
class_name InventoryItem

@export_category("Generic Statistics")
@export_group("Name")
@export var item_id : String
@export var item_name : String
@export_multiline var item_description : String
@export_group("Typing")
@export var supertype : String
@export var type : String
@export var subtype : String
@export_group("Materials")
@export var materials : Array[String]
@export_group("Textures")
@export var item_texture2D : Texture2D
@export_category("Weapon Statistics")
@export var is_weapon : bool = false
@export_group("Range")
@export var min_reach : int = 0
@export var max_reach : int = 1
@export var min_range : int = 0
@export var max_range : int = 6
@export var thrown_range : int = 2

@onready var item_sprite = $Sprite2D

func _ready():
	item_sprite.texture = item_texture2D

func _process(delta):
	pass

func move_item():
	var item = {
		"quantity": 1
	}

### [1] ###
# https://www.youtube.com/playlist?list=PL8VGDn5bxwDa8sAB-bz_l6aJbT_SnHrID
