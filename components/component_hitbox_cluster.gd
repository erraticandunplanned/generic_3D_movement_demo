extends Node
class_name HitboxCluster

@export_category("Components")
@export var hitbox : CollisionShape3D
@export var area_at_eyes : Area3D
@export var area_at_feet : Area3D
@export var melee_area : Area3D

func find_closest_object(search_range):
	### [1] ### find the closest object
	var min_dist = search_range
	var closest_valid_object = null
	#if area_at_feet.has_overlapping_bodies():
	for object in area_at_feet.get_overlapping_bodies(): 
		if not object.get_parent().is_in_group("active_ability"):
			var dist = hitbox.get_global_transform().origin.distance_to(object.get_global_transform().origin)
			if dist < min_dist:
				min_dist = dist
				closest_valid_object = object
	return closest_valid_object

func object_exists_at_eyes():
	var object_exists = false
	for object in area_at_eyes.get_overlapping_bodies(): 
		#if not object.get_parent().is_in_group("active_ability"):
		var dist = hitbox.get_global_transform().origin.distance_to(object.get_global_transform().origin)
		if dist < 5000 : #5000 
			object_exists = true
	return object_exists

func find_nearest_surface_normal(closest_valid_object):
	pass

### BIBLIOGRAPHY ###
### [1] ###
# closest object calculation from yoann on godot forums
# https://godotforums.org/d/17565-get-the-nearest-object/2
