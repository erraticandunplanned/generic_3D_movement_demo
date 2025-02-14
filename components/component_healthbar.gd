extends Node
class_name HealthComponent

@export_category("Components")
@export var player : CharacterBody3D
@export var statistics : StatisticsComponent

func _ready():
	pass

func _process(delta):
	pass

func recieve_damage(amount : int, type : String):
	pass

func recieve_healing(amount : int):
	pass
