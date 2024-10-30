extends Area2D

const ENEMY_LIMIT = 35
@export var enemy_count = 0
@onready var resources_manager = get_node("/root/Main/Resources")
@onready var enemy_progress_bar = get_parent().get_node("ProgressBar")

func _ready() -> void:
	enemy_progress_bar.value = 0
	enemy_progress_bar.max_value = ENEMY_LIMIT

	
func _process(delta: float) -> void:
	var gridWaste = get_tree().get_root().get_children()[-1].getWasteGrid()
	var countWaste = 0
	for w in gridWaste:
		if w.type != -1:
			countWaste += 1
	if enemy_count != countWaste:
		enemy_count = countWaste
		update_progress_bar()
	print(enemy_count)

func _on_body_entered(body: Node) -> void:
	if "Enemy" in body.name:
		enemy_count += 1
		update_progress_bar()
		resources_manager.add_enemy_passed()
		check_loss_condition()
		
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("enemies"):
		enemy_count -= 1
		update_progress_bar()

func update_progress_bar() -> void:
	# Met à jour la valeur de la jauge en fonction du nombre d'ennemis
	enemy_progress_bar.value = enemy_count

func check_loss_condition() -> void:
	if enemy_count >= ENEMY_LIMIT:
		# Affiche l'écran de défaite
		var game_over_screen = get_tree().get_current_scene().get_node("GameOver")
		game_over_screen.show()
		get_tree().paused = true
