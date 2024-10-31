extends Node2D

@onready var game_over_screen = $GameOver
var sceneVisible : bool = true # true pour Tower Defense, false pour Defenseas Crush
var wasteGrid
var healthSpriteGrid
static var defenseas_crush_instance = null

# Respecter le même ordre que dans res://Defenseas_Crush/waste.gd
var waste_sprite = [
		preload("res://Defenseas_Crush/sprites/bidon128.png"),
		preload("res://Defenseas_Crush/sprites/biere128.png"),
		preload("res://Defenseas_Crush/sprites/coca128.png"),
		preload("res://Defenseas_Crush/sprites/conteneur128.png"),
		preload("res://Defenseas_Crush/sprites/plastic_bottle128.png"),
		preload("res://Defenseas_Crush/sprites/trash_bag128.png"),
		preload("res://Defenseas_Crush/sprites/verre128.png")
		]
var sprite_health_size = 64

func _ready() -> void:
	game_over_screen.hide()
	
	wasteGrid = []
	healthSpriteGrid = []
	
	if not defenseas_crush_instance:
		var defenseas_crush_scene = preload("res://Defenseas_Crush/main.tscn")
		defenseas_crush_instance = defenseas_crush_scene.instantiate()
		defenseas_crush_instance.visible = false
		get_tree().get_root().add_child(defenseas_crush_instance)
	else:
		defenseas_crush_instance.cleanWaste()
		
	wasteGrid = defenseas_crush_instance.getWasteGrid()
	for i in range(wasteGrid.size()):
		wasteGrid[i].type = -1
		var new_sprite = Sprite2D.new()
		new_sprite.position = Vector2(520 + i%12 * 48, 980 - i/12 * 48)
		new_sprite.scale = Vector2(0.4,0.4)
		healthSpriteGrid.append(new_sprite)
		self.add_child(new_sprite)
	
func _process(delta: float) -> void:
	wasteGrid = defenseas_crush_instance.getWasteGrid()
	for i in range(wasteGrid.size()):
		if (wasteGrid[i].type != -1):
			healthSpriteGrid[i].visible = true
			healthSpriteGrid[i].texture = waste_sprite[wasteGrid[i].type]
		else:
			healthSpriteGrid[i].visible = false
	
	# Pour passer d'une scène à l'autre, en faisant en sorte qu'elles se déroulent en parallèle
	if Input.is_action_just_pressed("switchGame"):
		self.visible = not sceneVisible
		get_tree().get_root().get_node("Main/ItemsPanel").visible = not sceneVisible
		get_tree().get_root().get_node("Main/ResourcesUI").visible = not sceneVisible
		get_tree().get_root().get_node("Main/StatsUI").visible = not sceneVisible
		defenseas_crush_instance.visible = sceneVisible
		sceneVisible = not sceneVisible
		
	
	
	
