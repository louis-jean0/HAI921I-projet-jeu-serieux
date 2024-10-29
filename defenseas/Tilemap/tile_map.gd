extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var shader_material = $TileMap.material # Accéder au ShaderMaterial
	shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0) # Passer le temps en secondes
