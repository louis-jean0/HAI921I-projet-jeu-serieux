extends EnemyBase

class_name ClassicEnemy

func _init() -> void:
	speed = 50
	plastic_value = 10
	health = 10
	sprite_array = [
		preload("res://Enemies/sprites/bidon2.png"),
		preload("res://Enemies/sprites/biere.png"),
		preload("res://Enemies/sprites/coca.png"),
		preload("res://Enemies/sprites/bidon.png"),
		preload("res://Enemies/sprites/plastic_bottle.png"),
		preload("res://Enemies/sprites/trash_bag.png"),
		preload("res://Enemies/sprites/verre.png")
]
