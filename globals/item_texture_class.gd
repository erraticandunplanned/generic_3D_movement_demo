extends Resource
class_name ItemTexture

@export var atlas_id         : Array[String]
@export var atlas_coordinate : Vector2
@export var fill_color_A     : Color
@export var fill_color_B     : Color

func _init(p_atlas_id : Array[String] = ["","",""], p_atlas_coordinate := Vector2.ZERO, p_fill_color_A := Color.WHITE, p_fill_color_B := Color.WHITE):
	atlas_id = p_atlas_id
	atlas_coordinate = p_atlas_coordinate
	fill_color_A = p_fill_color_A
	fill_color_B = p_fill_color_B
