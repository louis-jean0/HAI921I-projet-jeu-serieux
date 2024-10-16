extends Node2D

@export var speed = 5
var boat
var pince
var cosCount = 0
var rangeYMove = 13
var initialYBoat = 580
var pinceY = 0
var boatLook = 1 # 1 pour left, -1 pour right (permet de bien positionner la pince)

var stringColor = Color(55,55,55)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boat = self.get_child(0)
	pince = boat.get_child(0)
	boat.animation="goLeft"
	boat.position = Vector2i(750,initialYBoat)
	pince.animation = "openGrap"
	pince.position = Vector2i(50,0)


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("grabAction"):
		pince.animation = "closeGrap"
	if Input.is_action_just_released("grabAction"):
		pince.animation = "openGrap"
	if Input.is_action_pressed("downPince"):
		if pinceY < 350:
			pinceY += 5
	else:
		if pinceY > 0:
			pinceY -= 5
		
	boat.position.y = initialYBoat + cos(cosCount)*rangeYMove
	cosCount += 0.08
	
	pince.position = Vector2i(50*boatLook,pinceY)
	
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
			
