extends GridContainer

# Taille de la grille : rows x columns
@export var grid_size = Vector2i(4, 12)
@export var delay_between_spawn = 0.01 # Pour les tests, ensuite les seront tomberont dans la mer depuis l'autre phase du jeu
@export var cell_size = Vector2i(128, 128)
@export var gridPosition = Vector2(360,754)
@export var tailleSequenceRecyclage = 3

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
			# On regarde si la position de la pince est comprise entre les 2 extrémités du sprite du déchet
			if gridPosition.x + w_position.x - cell_size.x/2 < aimX and aimX < gridPosition.x + w_position.x + cell_size.x/2: # Bien prendre en compte les coordonnées monde des cellules (et pas par rapport à la grille)
				if gridPosition.y + w_position.y - cell_size.y/8 < aimY and aimY < gridPosition.y + w_position.y + cell_size.y : # Si on voulait être précis il faudrait mettre ... + (7*cell_size.y)/8
					if hasToBeDeleted:
						self.remove_child(w.sprite)
					else: # Si hasToBeDeleted vaut false, cet appel de fonction sert à déterminer si on peut descendre la pince ou non
						return -2 
					var typeWaste = w.type
					w.type = -1
					return typeWaste
	return -1

func check_if_empty(positionWaste, typeWaste):
	var i = int((positionWaste.x + cell_size.x/1.9 - gridPosition.x) / cell_size.x) 
	var j = int(((600+cell_size.y) - (positionWaste.y - gridPosition.y)) / cell_size.y)	
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

func recycleWaste(positionWaste, typeWaste):
	var res = [] # Liste des déchets qui vont tomber suite au recyclage des déchets plus bas
	var i = int((positionWaste.x + cell_size.x/2 -gridPosition.x)/cell_size.x) 
	var j = int(((600+cell_size.y)-(positionWaste.y + cell_size.y/2 - gridPosition.y))/cell_size.y)
	
	# Vérification horizontale
	var tailleSeq = 1
	var extremeGauche = 0
	
	# Vers la gauche
	for offset in range(-1,-1*tailleSequenceRecyclage,-1):
		if i+offset >= 0:
			var checked_waste = listOfWaste[j*grid_size.y + i+offset]
			if checked_waste.type == typeWaste:
				tailleSeq += 1
				extremeGauche = offset
			else:
				break
		else:
			break
	
	# Vers la droite
	for offset in range(1,tailleSequenceRecyclage,1):
		if i+offset < grid_size.y:
			var checked_waste = listOfWaste[j*grid_size.y + i+offset]
			if checked_waste.type == typeWaste:
				tailleSeq += 1
			else:
				break
		else:
			break
	
	# Recyclage des déchets identifiés (si la taille de la séquence est supérieur ou égal au seuil défini)
	if tailleSeq >= tailleSequenceRecyclage:
		for offset in range(extremeGauche,extremeGauche+tailleSeq,1):
			var w = listOfWaste[j*grid_size.y + i+offset]
			self.remove_child(w.sprite)
			listOfWaste[j*grid_size.y + i+offset].type = -1
			
			# Identifier les déchets au dessus de celui qu'on vient de recycler
			for k in range(1,grid_size.x - j,1):
				var up_waste = listOfWaste[(j+k)*grid_size.y + i+offset]
				if up_waste.type != -1:
					var newWaste = Waste.new()
					newWaste.type = up_waste.type
					# Attention à bien calculer les coordonnées monde (en ajoutant la position de la grille)
					newWaste.sprite.position = up_waste.sprite.position + gridPosition
					newWaste.sprite.texture = up_waste.sprite.texture
					listOfWaste[(j+k)*grid_size.y + i+offset].type = -1
					self.remove_child(up_waste.sprite)
					res.append(newWaste)
				else:
					break
	
	# Vérification verticale (beaucoup plus simple que horizontale)
	tailleSeq = 1
	
	# Vers le bas (uniquement)
	for offset in range(-1,-1*tailleSequenceRecyclage,-1):
		if j+offset >= 0:
			var checked_waste = listOfWaste[(j+offset)*grid_size.y + i]
			if checked_waste.type == typeWaste:
				tailleSeq += 1
			else:
				break
		else:
			break
	
	# Recyclage des déchets identifiés (si la taille de la séquence est supérieur ou égal au seuil défini)
	if tailleSeq >= tailleSequenceRecyclage:
		for offset in range(0,-1*tailleSeq,-1):
			var w = listOfWaste[(j+offset)*grid_size.y + i]
			self.remove_child(w.sprite)
			listOfWaste[(j+offset)*grid_size.y + i].type = -1
	
	# Impossible d'avoir des déchets au dessus de ceux qu'on vient de recycler
	return res
		
		
	
	
