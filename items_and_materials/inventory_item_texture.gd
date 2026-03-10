extends Node2D

@onready var lines_texture = $lines
@onready var fillA_texture = $fill_A
@onready var fillB_texture = $fill_B

@onready var image_stack = [lines_texture, fillA_texture, fillB_texture]

func set_item_texture(tex : ItemTexture):
	if tex.atlas_id[0] == "": return
	for i in range(3):
		var ref_image = load("res://textures/item_images/" + tex.atlas_id[i])
		image_stack[i].texture = AtlasTexture.new()
		image_stack[i].texture.atlas = ref_image
		image_stack[i].texture.set_region(Rect2(tex.atlas_coordinate.x * 64, tex.atlas_coordinate.y * 64, 64, 64))
	fillA_texture.modulate = tex.fill_color_A
	fillB_texture.modulate = tex.fill_color_B

func clear_texture():
	for i in range(3):
		image_stack[i].texture = AtlasTexture.new()
	fillA_texture.modulate = Color.WHITE
	fillB_texture.modulate = Color.WHITE

func set_item_quantity(amt : int, add : bool = false):
	$quantity.text = str(int($quantity.text) + amt) if add else str(amt)
