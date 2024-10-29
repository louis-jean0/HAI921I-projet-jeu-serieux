extends Object

class_name Waste

static var texture_paths = [preload("res://sprites/bidon128.png"),
							preload("res://sprites/biere128.png"),
							preload("res://sprites/coca128.png"),
							preload("res://sprites/conteneur128.png"),
							preload("res://sprites/plastic128.png"),
							preload("res://sprites/plastic_bottle128.png"),
							preload("res://sprites/trash_bag128.png"),
							preload("res://sprites/verre128.png")
						   ]

var sprite : Sprite2D
var type : int

func _init() -> void:
	type = -1
	sprite = Sprite2D.new()
