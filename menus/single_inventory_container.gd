extends Node2D

func _set_size(size : int = 12):
	for i in range(0,12):
		if i >= size:
			$items.get_child(i).queue_free()
			$slotmap_64/slot_background.set_cell(Vector2i(i,0))
			$slotmap_64/container_background.set_cell(Vector2i(i,0))

func _set_texture(index : int, tex : ItemTexture):
	$items.get_child(index)._set_texture(tex)
