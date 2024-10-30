# EnemyBase.gd
extends CharacterBody2D

class_name EnemyBase

@export var speed: int
@export var health: int
@export var plastic_value: int
@export var sprite_array = []
var type_waste : int
var defenseas_crush_instance : Node = null

func _ready():
	# Assign a random sprite texture from the array or a default texture
	type_waste = randi() % sprite_array.size()
	defenseas_crush_instance = get_node("/root/Main").defenseas_crush_instance
	if sprite_array.size() > 0:
		$Sprite2D.texture = sprite_array[type_waste]
	$Sprite2D.scale.x = 0.25
	$Sprite2D.scale.y = 0.25

func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	if get_parent().get_progress_ratio() == 1:
		defenseas_crush_instance.waste_fall_in_sea(type_waste)
		queue_free()
	if health <= 0:
		handle_death()
		
func detach() -> void:
	pass

func handle_death() -> void:
	var resources_manager = get_node("/root/Main/Resources")
	resources_manager.add_plastic(plastic_value)
	queue_free()
