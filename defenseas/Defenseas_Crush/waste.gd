extends Object

class_name Waste

static var texture_paths = [preload("res://Defenseas_Crush/sprites/bidon128.png"),
							preload("res://Defenseas_Crush/sprites/biere128.png"),
							preload("res://Defenseas_Crush/sprites/coca128.png"),
							preload("res://Defenseas_Crush/sprites/conteneur128.png"),
							#preload("res://Defenseas_Crush/sprites/plastic128.png"),
							preload("res://Defenseas_Crush/sprites/plastic_bottle128.png"),
							preload("res://Defenseas_Crush/sprites/trash_bag128.png"),
							preload("res://Defenseas_Crush/sprites/verre128.png")
						   ]

var sprite : Sprite2D
var type : int

func _init() -> void:
	type = -1
	sprite = Sprite2D.new()
