extends Node2D

@onready var game_over_screen = $GameOver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_screen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switchGame"):
		get_tree().change_scene_to_file("res://Defenseas_Crush/main.tscn")
	
	
	
