extends Node
class_name HealthComponent

@export_category("Components")
@export var player : CharacterBody3D
@export var statistics : StatisticsComponent

func _ready():
	pass

func _process(_delta):
	pass

func recieve_damage(a_input : AttackClass):
	statistics.health -= a_input.amount
	print("health: ", statistics.health)

func recieve_healing(a_input : int):
	statistics.health += a_input
	print("health: ", statistics.health)
