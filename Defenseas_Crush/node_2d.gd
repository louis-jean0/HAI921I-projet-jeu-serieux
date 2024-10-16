extends Node2D

# Fonction pour créer un rectangle dynamique
func create_dynamic_rectangle(position: Vector2, size: Vector2, color: Color):
	# Instancier un nouveau ColorRect
	var rect = ColorRect.new()
	
	# Définir la position et la taille du rectangle
	rect.size = size  # Utilisez 'size' au lieu de 'rect_size'
	rect.position = position  # Utilisez 'position' au lieu de 'rect_position'
	
	# Définir la couleur du rectangle
	rect.color = color
	
	# Ajouter le rectangle à la scène
	add_child(rect)

# Fonction qui est appelée lorsque le nœud est prêt
func _ready():
	# Exemple de création de plusieurs rectangles
	create_dynamic_rectangle(Vector2(100, 100), Vector2(200, 100), Color(1, 0, 0))  # Rectangle rouge
	create_dynamic_rectangle(Vector2(350, 100), Vector2(150, 200), Color(0, 1, 0))  # Rectangle vert
	create_dynamic_rectangle(Vector2(550, 200), Vector2(100, 100), Color(0, 0, 1))  # Rectangle bleu
