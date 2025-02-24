extends Node

@onready var middle_camera = $Camera3D

var transitioning = false

func swap_camera(from_camera : Camera3D, to_camera : Camera3D, duration : float = 1.0):
	if transitioning: return
	
	var tween = get_tree().create_tween()
	
	## COPY THE PARAMETERS OF THE FIRST CAMERA
	middle_camera.fov = from_camera.fov
	middle_camera.cull_mask = from_camera.cull_mask
	
	## MOVE MIDDLE CAMERA TO START AND SET TO CURRENT
	middle_camera.global_transform = from_camera.global_transform
	middle_camera.current = true
	transitioning = true
	
	## MOVE TO FINAL CAMERA WHILE ADJUSTING PARAMETERS TO MATCH
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(middle_camera, "global_transform", to_camera.global_transform, duration).from(middle_camera.global_transform)
	tween.tween_property(middle_camera, "fov", to_camera.fov, duration).from(middle_camera.fov)
	
	## WAIT FOR COMPLETION AND SET FINAL CAMERA TO CURRENT
	await tween.finished
	to_camera.current = true
	transitioning = false

## [1] ##
# https://www.youtube.com/watch?v=8Lj3pUYuVe8
