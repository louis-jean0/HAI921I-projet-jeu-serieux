extends Path2D

var object_scene = preload("res://bidon.tscn")  # Charge la scène de l'objet
var spawn_positions = [Vector2(192, 0)]  # Positions de spawn

func _ready():
	$Timer.start()  # Démarre le Timer pour faire apparaître les objets

func spawn_object():
	var instance = object_scene.instantiate()  # Instancie l'objet
	add_child(instance)  # Ajoute l'objet à la scène
	instance.position = get_random_spawn_position()  # Définit une position de spawn

	# Crée une nouvelle instance de PathFollow2D
	var path_follow = PathFollow2D.new()  
	instance.add_child(path_follow)  # Ajoute PathFollow2D comme enfant de l'instance
	instance.path_follow = path_follow  # Assigne la référence de PathFollow2D à l'instance

	var path_node = get_node("Path2D")  # Utilise get_node pour obtenir Path2D
	if path_node:  # Vérifie que le nœud existe
		var curve = path_node.get_curve()  # Obtiens la courbe du chemin
		path_follow.set_path(curve)  # Associe la courbe à PathFollow2D
		path_follow.offset = 0  # Commence au début du chemin

func get_random_spawn_position():
	return spawn_positions[randi() % spawn_positions.size()]  # Renvoie une position aléatoire

func _on_timer_timeout() -> void:
	spawn_object()
	print("spawn")
