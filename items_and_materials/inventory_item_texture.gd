extends Node2D

func _set_texture(coord : Vector2, fill_A_color : Color = Color.WHITE, fill_B_color : Color = Color.WHITE):
	for sprite in [$texture,$fill_A,$fill_B]:
		sprite.texture.region = Rect2(coord.x, coord.y, 64, 64)
	$fill_A.modulate = fill_A_color
	$fill_B.modulate = fill_B_color

func _set_quantity(amt : int, add : bool = false):
	$quantity.text = int($quantity.text) + amt if add else amt
