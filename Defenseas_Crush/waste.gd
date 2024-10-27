extends Object

class_name Waste

static var texture_paths = [preload("res://waste1.png"), preload("res://waste2.png"), preload("res://waste3.png")]
var sprite : Sprite2D
var type : int

func _init() -> void:
	type = -1
	sprite = Sprite2D.new()
