extends GridContainer


@export var delay_between_spawn = 0.2
# Taille de la grille : rows x columns
@export var grid_size = Vector2i(5, 15)
# Taille d'une cellule : sprite 64 x 64
@export var cell_size = Vector2i(64, 64)
@export var gridPosition = Vector2i(340,704)

var indWaste

var texture_paths = [preload("res://waste1.png"), preload("res://waste2.png"), preload("res://waste3.png")]
var listTypeWaste = [] # Permettra de connaitre les objets manipulé par la pince

func _ready():
	clear_grid()
	position = gridPosition
	indWaste = 0
	for i in range(grid_size.x*grid_size.y):
		listTypeWaste.append(-1)
	
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
		var type = randi() % texture_paths.size()
		listTypeWaste[indWaste] = type
		newWaste.texture = texture_paths[type]
		newWaste.position = Vector2i(indWaste % grid_size.y * cell_size.x, 600 - (indWaste / grid_size.y * cell_size.y))
		indWaste+=1
		# Ajouter le sprite à la grille
		self.add_child(newWaste)

func checkAt(hasToBeDeleted, aimX,aimY):
	for child in self.get_children():
		if child is Sprite2D:
			if child.position.x + gridPosition.x < aimX and aimX < child.position.x + gridPosition.x + cell_size.x: # Bien prendre en compte les coordonnées monde des cellules (et pas par rapport à la grille)
				if child.position.y + gridPosition.y < aimY and aimY < child.position.y + gridPosition.y + cell_size.y   :
					if hasToBeDeleted:
						self.remove_child(child)
					else: # Si hasToBeDeleted vaut false, cet appel de fonction sert à déterminer si on peut descendre la pince ou non
						return -2 # 
					var i = int((aimX-gridPosition.x)/cell_size.x) 
					var j = int(((600+cell_size.y)-(aimY-gridPosition.y))/cell_size.y)	
					var typeWaste = listTypeWaste[j*grid_size.y + i]
					listTypeWaste[j*grid_size.y + i] = -1
					return typeWaste	
	return -1

func check_if_empty(positionWaste, typeWaste):
	var i = int((positionWaste.x + cell_size.x/2 -gridPosition.x)/cell_size.x) 
	var j = int(((600+cell_size.y)-(positionWaste.y + cell_size.y/2 - gridPosition.y))/cell_size.y)	
	if i >= 0 and i < grid_size.y and j >= 0 and j < grid_size.x:
		if j == 0 or listTypeWaste[(j-1)*grid_size.y + i] != -1: # Si il y a bien un déchet en dessous ou qu'on est au fond
			if listTypeWaste[j*grid_size.y + i] == -1 : # S'il n'y a pas de déchet à cet emplacement
				var newWaste = Sprite2D.new()
				listTypeWaste[j*grid_size.y + i] = typeWaste
				newWaste.texture = texture_paths[typeWaste]
				newWaste.position = Vector2i(i * cell_size.x, 600 - (j * cell_size.y))
				# Ajouter le sprite à la grille
				self.add_child(newWaste)
				return true
	return false
