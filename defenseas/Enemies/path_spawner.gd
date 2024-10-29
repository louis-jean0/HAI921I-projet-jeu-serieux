extends Node2D

@export var spawn_rates_config = {
	"FirstStage": [2.5, 3.0, 3.0],  # Taux de spawn pour les chemins du premier niveau
	"SecondStage": [1.0, 2.5, 1.8],  # Taux de spawn pour les chemins du second niveau
}

var spawn_timers = []  # Liste pour stocker les timers de chaque chemin

func _ready():
	# Récupérer la scène de niveau active
	var level = get_node("../LevelContainer").get_child(0)
	var level_name = level.name
	var spawn_rates = spawn_rates_config.get(level_name, [])

	# Récupérer les chemins dans la scène de niveau
	var paths = level.get_children().filter(func(child): return child is Path2D)

	# Créer un timer pour chaque chemin
	for i in range(paths.size()):
		var spawn_timer = Timer.new()
		spawn_timer.wait_time = spawn_rates[i] if i < spawn_rates.size() else 2.0
		spawn_timer.one_shot = false
		
		# Connecter le timer à la fonction de spawn avec l'index du chemin
		spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout").bind(i))
		
		add_child(spawn_timer)
		spawn_timer.start()
		spawn_timers.append(spawn_timer)

func _on_spawn_timer_timeout(path_index):
	# Récupérer le niveau et vérifier les chemins
	var level = get_node("../LevelContainer").get_child(0)
	var paths = level.get_children().filter(func(child): return child is Path2D)
	
	# Assure-toi que l'index est valide
	if path_index < 0 or path_index >= paths.size():
		print("Index de chemin invalide")
		return

	# Créer l'ennemi sur le chemin spécifié
	var chosen_path = paths[path_index]
	create_enemy_on_path(chosen_path, "ClassicEnemy")

func create_enemy_on_path(path: Path2D, enemy_type : String):
	# Créer dynamiquement un PathFollow2D et assigner le Path2D choisi
	var path_follow = PathFollow2D.new()
	path_follow.loop = false # Important
	path.add_child(path_follow)
	
	var enemy_scene : PackedScene
	match enemy_type:
		"ClassicEnemy":
			enemy_scene = preload("res://Enemies/ClassicEnemy.tscn")
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		path_follow.add_child(enemy)
