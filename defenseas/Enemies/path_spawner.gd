extends Node2D

@export var wave_config = [
	{"enemy_count": 50, "spawn_rates": [2.5, 2.5, 2.5], "enemy_type": "ClassicEnemy", "message": "Première vague !\nLes eaux sont envahies par des emballages polluants ! Rétablis l'équilibre !"},
	{"enemy_count": 100, "spawn_rates": [2.0, 2.0, 2.0], "enemy_type": "FastEnemy", "message": "Deuxième vague !\nLes usines déversent des tonnes de plastique dans la mer ! Mets un terme à ça !"},
	{"enemy_count": 150, "spawn_rates": [1.0, 1.0, 1.0], "enemy_type": "FastAndStrongerEnemy", "message": "Dernière vague !\nCoca-Cola déverse ses déchets dans les eaux ! Empêche-les !"}
	]
@export var total_enemies = calculate_total_enemies()

func calculate_total_enemies() -> int:
	var total = 0
	for wave in wave_config:
		total += wave["enemy_count"]
	return total

var current_wave_index = 0  # Index de la vague actuelle
var enemies_spawned_in_wave = 0
var current_wave  # La vague actuelle (dictionnaire)
var spawn_timers = []

@onready var wave_message_label = $WaveMessageLabel

func _ready():
	start_next_wave()
	connect("enemy_died", Callable(self, "_on_enemy_died"))
	
func _process(delta: float) -> void:
	pass

func start_next_wave():
	if current_wave_index >= wave_config.size():
		get_tree().get_root().get_node("World").visible = false
		get_tree().get_root().get_node("Main").visible = true
		get_tree().get_root().get_node("Main/ItemsPanel").visible = true
		get_tree().get_root().get_node("Main/ResourcesUI").visible = true
		get_tree().get_root().get_node("Main/StatsUI").visible = true
		var win_scene = get_tree().get_current_scene().get_node("Win")
		win_scene.show()
		get_tree().paused = true
		return
	
	# Récupère la configuration de la vague actuelle
	current_wave = wave_config[current_wave_index]
	enemies_spawned_in_wave = 0
	
	# Affiche le message de la vague
	show_wave_message(current_wave.message)
	
	# Récupère la scène de niveau active
	var level = get_node("../LevelContainer").get_child(0)
	var paths = level.get_children().filter(func(child): return child is Path2D)
	
	await get_tree().create_timer(5.0).timeout
	
	# Configure un timer pour chaque chemin
	for i in range(paths.size()):
		var spawn_timer = Timer.new()
		spawn_timer.wait_time = current_wave.spawn_rates[i] if i < current_wave.spawn_rates.size() else 2.0
		spawn_timer.one_shot = false
		
		# Connecte le timer au spawn d’ennemis
		spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout").bind(i))
		
		add_child(spawn_timer)
		spawn_timer.start()
		spawn_timers.append(spawn_timer)

func _on_spawn_timer_timeout(path_index):
	if enemies_spawned_in_wave >= current_wave.enemy_count:
			stop_wave_timers()
			current_wave_index += 1
			await get_tree().create_timer(20.0).timeout
			start_next_wave()
	
	# Récupère le niveau et les chemins
	var level = get_node("../LevelContainer").get_child(0)
	var paths = level.get_children().filter(func(child): return child is Path2D)
	
	if path_index >= 0 and path_index < paths.size():
		create_enemy_on_path(paths[path_index], current_wave.enemy_type)
		enemies_spawned_in_wave += 1

func create_enemy_on_path(path: Path2D, enemy_type: String):
	var path_follow = PathFollow2D.new()
	path_follow.loop = false
	path.add_child(path_follow)
	
	var enemy_scene: PackedScene
	enemy_scene = preload("res://Enemies/ClassicEnemy.tscn")
	
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		match enemy_type:
			"ClassicEnemy":
				pass
			"FastEnemy":
				enemy.speed = 100
			"FastAndStrongerEnemy":
				enemy.speed = 150
				enemy.health = 20
		path_follow.add_child(enemy)
		
func stop_wave_timers():
	for timer in spawn_timers:
		timer.stop()
		timer.queue_free()
	spawn_timers.clear()

# Affiche le message de la vague pendant un court instant
func show_wave_message(message: String):
	wave_message_label.bbcode_text = "[center][b]" + message + "[/b][/center]"
	wave_message_label.visible = true
	await get_tree().create_timer(5.0).timeout  # Durée d’affichage du message
	wave_message_label.visible = false
