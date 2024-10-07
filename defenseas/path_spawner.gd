extends Node2D


@onready var path = preload("res://Stage_1.tscn")
@onready var path2 = preload("res://Stage_2.tscn")


func _on_timer_timeout() -> void:
	var tempPath = path.instantiate();
	add_child(tempPath)
	var tempPath2 = path2.instantiate();
	add_child(tempPath2)
