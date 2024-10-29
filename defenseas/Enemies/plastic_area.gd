extends Area2D

@export var initial_amount = 0
@export var sprite_array = [
	preload("res://Enemies/sprites/bidon.png"),
	preload("res://Enemies/sprites/bidon2.png"),
	preload("res://Enemies/sprites/biere.png"),
	preload("res://Enemies/sprites/coca.png"),
	preload("res://Enemies/sprites/plastic_bottle.png"),
	preload("res://Enemies/sprites/trash_bag.png"),
	preload("res://Enemies/sprites/verre.png")
]

var current_plastic = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_plastic = initial_amount
	if sprite_array.size() > 0:
		$Sprite2D.texture = sprite_array[randi() % sprite_array.size()]
	$Sprite2D.scale = Vector2(0.1,0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_plastic_visual()
	
func add_plastic(amount: int) -> void:
	current_plastic += amount
	
func update_plastic_visual() -> void:
	var new_scale: float = 1 + (current_plastic / 100)
	$Sprite2D.scale = Vector2(new_scale,new_scale)
