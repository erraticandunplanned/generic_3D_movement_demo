extends Node3D

func _physics_process(_delta):
	await get_tree().create_timer(10).timeout
	queue_free()
