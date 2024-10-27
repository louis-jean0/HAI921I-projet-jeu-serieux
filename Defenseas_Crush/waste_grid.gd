extends GridContainer


@export var delay_between_spawn = 0.2
# Taille de la grille : rows x columns
@export var grid_size = Vector2i(5, 15)
# Taille d'une cellule : sprite 64 x 64
@export var cell_size = Vector2i(64, 64)
@export var gridPosition = Vector2i(340,704)

var indWaste
var listOfWaste = []

func _ready():
	clear_grid()
	position = gridPosition
	indWaste = 0
	for i in range(grid_size.x*grid_size.y):
		var w = Waste.new()
		listOfWaste.append(w)
		self.add_child(w.sprite) # Ajoute le sprite à la grille
	
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
		var waste = listOfWaste[indWaste]
		var newType = randi() % Waste.texture_paths.size()
		waste.type = newType
		waste.sprite.texture = Waste.texture_paths[newType]
		waste.sprite.position = Vector2i(indWaste % grid_size.y * cell_size.x, 600 - (indWaste / grid_size.y * cell_size.y))
		indWaste+=1

func checkAt(hasToBeDeleted, aimX,aimY):
	for i in range(listOfWaste.size()):
		var w = listOfWaste[i]
		if w.type != -1:
			var w_position = w.sprite.position
			if w_position.x + gridPosition.x < aimX and aimX < w_position.x + gridPosition.x + cell_size.x: # Bien prendre en compte les coordonnées monde des cellules (et pas par rapport à la grille)
				if w_position.y + gridPosition.y < aimY and aimY < w_position.y + gridPosition.y + cell_size.y   :
					if hasToBeDeleted:
						self.remove_child(w.sprite)
					else: # Si hasToBeDeleted vaut false, cet appel de fonction sert à déterminer si on peut descendre la pince ou non
						return -2 
					var typeWaste = w.type
					w.type = -1
					return typeWaste
	return -1

func check_if_empty(positionWaste, typeWaste):
	var i = int((positionWaste.x + cell_size.x/2 -gridPosition.x)/cell_size.x) 
	var j = int(((600+cell_size.y)-(positionWaste.y + cell_size.y/2 - gridPosition.y))/cell_size.y)	
	if i >= 0 and i < grid_size.y and j >= 0 and j < grid_size.x:
		if j == 0 or listOfWaste[(j-1)*grid_size.y + i].type != -1: # Si il y a bien un déchet en dessous ou qu'on est au fond
			if listOfWaste[j*grid_size.y + i].type == -1 : # S'il n'y a pas de déchet à cet emplacement
				var newWaste = listOfWaste[j*grid_size.y + i]
				newWaste.type = typeWaste
				newWaste.sprite.texture = Waste.texture_paths[typeWaste]
				newWaste.sprite.position = Vector2i(i * cell_size.x, 600 - (j * cell_size.y))
				listOfWaste[j*grid_size.y + i] = newWaste
				# Ajouter le sprite à la grille
				self.add_child(newWaste.sprite)
				return true
	return false
