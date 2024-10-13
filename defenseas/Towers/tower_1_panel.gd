extends Panel

@onready var tower = preload("res://Towers/first_tower.tscn")
var current_tower = null  # Variable pour stocker la tour en cours de placement

func _on_gui_input(event):
	# Vérifier si l'utilisateur appuie sur le bouton gauche de la souris
	if event is InputEventMouseButton and event.button_mask == 1:
		if event.is_pressed():
			# Bouton gauche enfoncé, créer une tour
			current_tower = tower.instantiate()
			add_child(current_tower)
			current_tower.global_position = event.global_position
			current_tower.process_mode = Node.PROCESS_MODE_DISABLED  # Désactiver le processus temporairement
		else:
			# Bouton gauche relâché, arrêter de suivre la souris et activer la tour
			if current_tower:
				current_tower.process_mode = Node.PROCESS_MODE_INHERIT  # Réactiver le processus
				current_tower = null  # Réinitialiser la tour actuelle
				
	# Si la tour est en cours de placement, la faire suivre la souris
	if current_tower and event is InputEventMouseMotion:
		current_tower.global_position = event.global_position
