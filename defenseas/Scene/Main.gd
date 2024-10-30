extends Node2D

@onready var game_over_screen = $GameOver
var defenseas_crush_instance : Node = null
var sceneVisible : bool = true # true pour Tower Defense, false pour Defenseas Crush

func _ready() -> void:
	game_over_screen.hide()
	
	var defenseas_crush_scene = load("res://Defenseas_Crush/main.tscn")
	defenseas_crush_instance = defenseas_crush_scene.instantiate()
	defenseas_crush_instance.visible = false
	get_tree().get_root().add_child(defenseas_crush_instance)

func _process(delta: float) -> void:
	# Pour passer d'une scène à l'autre, en faisant en sorte qu'elles se déroulent en parallèle
	if Input.is_action_just_pressed("switchGame"):
		self.visible = not sceneVisible
		defenseas_crush_instance.visible = sceneVisible
		sceneVisible = not sceneVisible
		
	
	
	
