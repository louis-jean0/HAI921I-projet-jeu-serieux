extends CharacterBody2D

@export var speed = 50

@export var sprite_array = [
	preload("res://bidon2-removebg-preview.png"),
	preload("res://bidon-removebg-preview.png"),
	preload("res://biere-removebg-preview.png"),
	preload("res://coca-removebg-preview.png"),
	preload("res://trash_bag-removebg-preview.png"),
	preload("res://verre-removebg-preview.png")
]

func _ready():
	# Assign a random sprite texture from the array
	$Sprite2D.texture = sprite_array[randi() % sprite_array.size()]
	$Sprite2D.scale.x=0.25
	$Sprite2D.scale.y=0.25
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().set_progress(get_parent().get_progress()+speed*delta)
	if get_parent().get_progress_ratio() == 1:
		queue_free()
