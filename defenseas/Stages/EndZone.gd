extends Area2D

const ENEMY_LIMIT = 100
var enemy_count = 0

func _ready() -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if "Enemy" in body.name:
		enemy_count += 1
		#print("Ennemi atteint l'océan. Compteur d'ennemis:", enemy_count)
		check_loss_condition()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("enemies"):
		enemy_count -= 1
		print("Ennemi quitté l'océan. Compteur d'ennemis:", enemy_count)

func check_loss_condition() -> void:
	if enemy_count > ENEMY_LIMIT:
		#print("Perte du jeu ! Trop d'ennemis ont atteint l'océan.")
		var game_over_screen = get_tree().get_current_scene().get_node("GameOver")
		game_over_screen.show()
