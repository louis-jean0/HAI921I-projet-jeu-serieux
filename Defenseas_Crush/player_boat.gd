extends Node2D

@export var speed = 8
var boat
var pince
var cosCount = 0
var rangeYMove = 5
var initialYBoat = 580
var pinceY = 0
var boatLook = 1 # 1 pour left, -1 pour right (permet de bien positionner la pince)
var scaleX
var scaleY
var holdingWaste # Déchet porté par la pince
var isHoldingWaste = false
var fallingWaste = []
var fallingSpeed = 5
var window_size
var pinceSpeed = 5
var yLimit = 350
var hasTouchedWaste = false

var stringColor = Color(55,55,55)
var wasteGrid

var frameIndex
var spriteFrames
var grabTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_size = get_viewport_rect().size # Récupère les dimensions de la fenêtre
	boat = self.get_child(0)
	pince = boat.get_child(0)
	boat.animation="goLeft"
	position = Vector2i(0,0)
	boat.position = Vector2i(750,initialYBoat)
	pince.animation = "openGrap"
	pince.position = Vector2i(50,0)
	wasteGrid = get_parent().get_node("wasteGrid")
	scaleX = pince.scale.x
	scaleY = pince.scale.y
	frameIndex = pince.get_frame()
	spriteFrames = pince.get_sprite_frames()
	grabTexture = spriteFrames.get_frame_texture("closeGrap", frameIndex)

func _draw():
	# Dessine le fil reliant le bateau à la pince
	draw_line(Vector2(boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook, boat.position.y - 50), Vector2(boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook, boat.position.y + pince.position.y*2), Color.DARK_SLATE_GRAY, 10.0)

	# Dessine un point là où vise la pince
	#draw_circle(Vector2i( boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10*boatLook + 20, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY + 10), 10, Color.DARK_RED)

func deleteSprite2D(wasteToDelete):
	# wasteToDelete.queue_free() # Supprime le noeud de la scène
	self.remove_child(wasteToDelete.sprite)
	# wasteToDelete = null
	
func _process(delta):	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"): 
		velocity.x = -1
	if Input.is_action_just_pressed("grabAction"):
		pince.animation = "closeGrap"
		var typeHold = wasteGrid.checkAt(true, boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10*boatLook + 20, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY + 15)
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
			if wasteGrid.checkAt(false, boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY) != -2:
				if not hasTouchedWaste:
					pinceY += pinceSpeed
			else:
				hasTouchedWaste = true
				pinceY -= pinceSpeed
		else:
			if wasteGrid.checkAt(false, boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY) == -2:
				pinceY -= pinceSpeed
			else:
				pinceY = yLimit
	else:
		hasTouchedWaste = false
		if pinceY > 0:
			pinceY -= 5
			
	boat.position.y = initialYBoat + cos(cosCount)*rangeYMove
	cosCount += 0.08
	
	pince.position = Vector2i(50*boatLook,pinceY)
	
	if isHoldingWaste:
		holdingWaste.sprite.position = Vector2i(boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY)
	
	for i in range(fallingWaste.size()):
		# Si besoin de vérifier que fallingWaste[i] != null, faire --> if fallingWaste[i]
		var w = fallingWaste[i]
		w.sprite.position.y += fallingSpeed
		if w.sprite.position.y > wasteGrid.gridPosition.y: # Ca ne sert à rien d'appeler check_if_empty au dela de cette hauteur
			if wasteGrid.check_if_empty(w.sprite.position, w.type):
				deleteSprite2D(w)
				fallingWaste.remove_at(i)
				var newWasteFalling = wasteGrid.recycleWaste(w.sprite.position, w.type)
				print("Il y a des déchets à faire tomber : ", newWasteFalling.size())
				for d in range(newWasteFalling.size()):
					self.add_child(newWasteFalling[d].sprite)
				break # On est obligé de stopper la boucle for car les indices des éléments changent à cause du remove_at
		
		# Le déchet tombe dans le vide
		if w.sprite.position.y > window_size.y + 64:
			deleteSprite2D(w)
			fallingWaste.remove_at(i)
			break # On est obligé de stopper la boucle for car les indices des éléments changent à cause du remove_at
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if velocity.x > 0:
			if boat.position.x < 1550:
				boat.position += velocity
				boat.animation = "goRight"
				boatLook = -1
		else:
			if boat.position.x > 110:
				boat.position += velocity
				boat.animation = "goLeft"
				boatLook = 1
	
	queue_redraw()
