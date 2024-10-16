extends GridContainer


@export var delay_between_spawn = 0.2
# Taille de la grille : rows x columns
@export var grid_size = Vector2i(5, 15)
# Taille d'une cellule : sprite 64 x 64
@export var cell_size = Vector2i(64, 64)
@export var gridPosition = Vector2i(340,724)

var indWaste = 0

var texture_paths = [preload("res://waste1.png"), preload("res://waste2.png"), preload("res://waste3.png")]

func _ready():
	clear_grid()
	position = gridPosition
	
	var timer = Timer.new()
	timer.wait_time = delay_between_spawn
	# Le timer recommence quand il termine
	timer.one_shot = false  
	timer.timeout.connect(spawn_new_object)
	add_child(timer)
	timer.start()
		
func clear_grid():
	for child in self.get_children():
		self.remove_child(child)
		
func spawn_new_object():
	if indWaste < grid_size.x * grid_size.y:
		var newWaste = Sprite2D.new()
		newWaste.texture = texture_paths[randi() % texture_paths.size()]
		newWaste.position = Vector2i(indWaste % grid_size.y * cell_size.x, 600 - (indWaste / grid_size.y * cell_size.y))
		indWaste+=1
		# Ajouter le sprite à la grille
		self.add_child(newWaste)
