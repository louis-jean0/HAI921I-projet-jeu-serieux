extends Node2D

@export var speed = 500
var boat
var pince
var cosCount = 0
var rangeYMove = 5 # Doucement sur cette valeur, sinon la pince perd en précision
var initialYBoat = 580
var minPinceY = 50
var pinceY = minPinceY
var scalePince
var holdingWaste # Instance de Waste portée par la pince
var isHoldingWaste = false
var fallingWaste = []
var fallingSpeed = 350
var window_size
var pinceSpeed = 350
var yLimit = 400
var hasTouchedWaste = false

var stringColor = Color(55,55,55)
var wasteGrid

# Dimension du sprite de la pince
var grabSpriteSize
# Dimension du sprite du bateau
var boatSpriteSize

func clearSprite():
	for s in self.get_children():
		if s is Sprite2D:
			self.remove_child(s)
			
func getSizeOfSprite(sprite, sprite_name):
	var frameIndex = sprite.get_frame()
	var spriteFrames = sprite.get_sprite_frames()
	var getTexture = spriteFrames.get_frame_texture(sprite_name, frameIndex)
	return getTexture.get_size()

func addWasteInFalling(new_waste):
	self.add_child(new_waste.sprite)
	fallingWaste.append(new_waste)

func _ready() -> void:
	window_size = get_viewport_rect().size # Récupère les dimensions de la fenêtre
	boat = self.get_child(0)
	pince = boat.get_child(0)
	boat.animation="goLeft"
	position = Vector2i(0,0)
	boat.position = Vector2i(750,initialYBoat)
	pince.animation = "openGrap"
	pince.position = Vector2i(0,minPinceY)
	wasteGrid = get_parent().get_node("wasteGrid")
	scalePince = pince.scale
	
	grabSpriteSize = getSizeOfSprite(pince, "closeGrap")
	boatSpriteSize = getSizeOfSprite(boat, "goLeft")

func _draw():
	# Dessine le fil reliant le bateau à la pince
	draw_line(Vector2(boat.position.x, boat.position.y), Vector2(boat.position.x, boat.position.y + pince.position.y*2), Color.DARK_SLATE_GRAY, 10.0)
	# Dessine un point là où vise la pince
	# draw_circle(Vector2i(boat.position.x + (grabSpriteSize.x * scalePince.x)/2 - 30, boat.position.y + pince.position.y*2 + grabSpriteSize.y*scalePince.y + 15), 10, Color.DARK_RED)

func deleteSprite2D(wasteToDelete):
	# wasteToDelete.queue_free() # Supprime le noeud de la scène
	self.remove_child(wasteToDelete.sprite)
	# wasteToDelete = null
	
func _process(delta):	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"): 
		velocity.x = -1
	if Input.is_action_just_pressed("grabAction"):
		pince.animation = "closeGrap"
		var typeHold = wasteGrid.checkAt(true, boat.position.x + (grabSpriteSize.x * scalePince.x)/2 - 30, boat.position.y + pince.position.y*2 + grabSpriteSize.y*scalePince.y + 30)
		if typeHold != -1:
			isHoldingWaste = true
			holdingWaste = Waste.new()
			holdingWaste.type = typeHold
			holdingWaste.sprite.texture = Waste.texture_paths[typeHold]
			self.add_child(holdingWaste.sprite) # Ajoute le Sprite2D à la scène (sinon il n'est pas dessiné)
			
	if Input.is_action_just_released("grabAction"):
		pince.animation = "openGrap"
		if isHoldingWaste:
			isHoldingWaste = false
			# Réinitialise le sprite porté par la pince
			# On fait une copie du déchet tenu jusqu'à maintenant
			var fw = Waste.new()
			fw.type = holdingWaste.type
			fw.sprite.position = holdingWaste.sprite.position
			fw.sprite.texture = holdingWaste.sprite.texture
			deleteSprite2D(holdingWaste)
			self.add_child(fw.sprite)
			fallingWaste.append(fw)
		
	if Input.is_action_pressed("downPince"):
		if pinceY < yLimit:
			if wasteGrid.checkAt(false, boat.position.x + (grabSpriteSize.x * scalePince.x)/2 - 30, boat.position.y + pince.position.y*2 + grabSpriteSize.y*scalePince.y) != -2:
				if not hasTouchedWaste:
					pinceY += pinceSpeed * delta
			else:
				hasTouchedWaste = true
				pinceY -= pinceSpeed * delta
		else:
			if wasteGrid.checkAt(false, boat.position.x + (grabSpriteSize.x * scalePince.x)/2 - 30, boat.position.y + pince.position.y*2 + grabSpriteSize.y*scalePince.y) == -2:
				pinceY -= pinceSpeed * delta
			else:
				pinceY = yLimit
	else:
		hasTouchedWaste = false
		if pinceY > minPinceY:
			pinceY -= 5
			
	boat.position.y = initialYBoat + cos(cosCount)*rangeYMove
	cosCount += 0.08
	
	pince.position = Vector2i(0,pinceY)
	
	if isHoldingWaste:
		holdingWaste.sprite.position = Vector2i(boat.position.x + (grabSpriteSize.x * scalePince.x)/2 - 32, boat.position.y + pince.position.y*2 +grabSpriteSize.y*scalePince.y)
	
	for i in range(fallingWaste.size()):
		# Si besoin de vérifier que fallingWaste[i] != null, faire --> if fallingWaste[i]
		var w = fallingWaste[i]
		w.sprite.position.y += fallingSpeed * delta
		if w.sprite.position.y > wasteGrid.gridPosition.y: # Ca ne sert à rien d'appeler check_if_empty au dela de cette hauteur
			if wasteGrid.check_if_empty(w.sprite.position, w.type):
				deleteSprite2D(w)
				fallingWaste.remove_at(i)
				var newWasteFalling = wasteGrid.recycleWaste(w.sprite.position, w.type)
				for d in range(newWasteFalling.size()):
					fallingWaste.append(newWasteFalling[d])
					self.add_child(newWasteFalling[d].sprite)
				break # On est obligé de stopper la boucle for car les indices des éléments changent à cause du remove_at
		
		# Le déchet tombe dans le vide
		if w.sprite.position.y > window_size.y + 512:
			deleteSprite2D(w)
			fallingWaste.remove_at(i)
			break # On est obligé de stopper la boucle for car les indices des éléments changent à cause du remove_at
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * delta
		if velocity.x > 0:
			if boat.position.x < 190 + window_size.x + boatSpriteSize.x/2 :
				boat.position += velocity
				boat.animation = "goRight"
		else:
			if boat.position.x >  227 + boatSpriteSize.x/2 :
				boat.position += velocity
				boat.animation = "goLeft"
	
	queue_redraw()
