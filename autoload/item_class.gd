#extends Node
class_name BasicItem

var quantity : int = 1
var item_id : String = "blank"

var name_default : String
var name_custom : String
var name_description : String

var materials : Array[String] = [""]
var textures : Array[Texture2D]

var item_scene_path : String
