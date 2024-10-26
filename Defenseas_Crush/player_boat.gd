extends Node2D

@export var speed = 5
var boat
var pince
var cosCount = 0
var rangeYMove = 13
var initialYBoat = 580
var pinceY = 0
var boatLook = 1 # 1 pour left, -1 pour right (permet de bien positionner la pince)
var scaleX
var scaleY
var holdingWaste # Sprite du déchet porté par la pince
var isHoldingWaste = false
var fallingWaste = []
var fallingSpeed = 3
var window_size

var stringColor = Color(55,55,55)
var texture_paths = [preload("res://waste1.png"), preload("res://waste2.png"), preload("res://waste3.png")]
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
	# draw_circle(Vector2i(boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY), 9.3905, Color.DARK_RED)
	
func _process(delta):	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"): 
		velocity.x -= 1
	if Input.is_action_just_pressed("grabAction"):
		pince.animation = "closeGrap"
	
		var typeWaste = wasteGrid.checkAt(boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY)
		if typeWaste != -1:
			isHoldingWaste = true
			holdingWaste = Sprite2D.new()
			holdingWaste.texture = texture_paths[typeWaste]
			self.add_child(holdingWaste) # Ajoute le Sprite2D à la scène (sinon il n'est pas dessiné)
			
	if Input.is_action_just_released("grabAction"):
		pince.animation = "openGrap"
		if isHoldingWaste:
			isHoldingWaste = false
			# Réinitialise le sprite porté par la pince
			var fw = holdingWaste.duplicate()
			self.add_child(fw)
			fallingWaste.append(fw)
			holdingWaste.queue_free() # Supprime le noeud de la scène
			holdingWaste = null
		
	if Input.is_action_pressed("downPince"):
		if pinceY < 350:
			pinceY += 5
	else:
		if pinceY > 0:
			pinceY -= 5
		
	boat.position.y = initialYBoat + cos(cosCount)*rangeYMove
	cosCount += 0.08
	
	pince.position = Vector2i(50*boatLook,pinceY)
	
	if isHoldingWaste:
		holdingWaste.position = Vector2i(boat.position.x + pince.position.x + grabTexture.get_size().x * scaleX/1.5 * boatLook + 10, boat.position.y + pince.position.y*2 + grabTexture.get_size().y*scaleY)
	
	for i in range(fallingWaste.size()):
		# Si besoin de vérifier que fallingWaste[i] != null, faire --> if fallingWaste[i]
		fallingWaste[i].position.y += fallingSpeed
		if fallingWaste[i].position.y > window_size.y + 64:
			fallingWaste[i].queue_free() # Supprime le noeud de la scène
			fallingWaste[i] = null
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
