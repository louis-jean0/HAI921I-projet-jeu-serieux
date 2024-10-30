extends Panel

@onready var tower = preload("res://Towers/first_tower.tscn")
var tower_value = 100 # Prix de la tour
@onready var valid_tilemap = get_tree().get_root().get_node("Main/Zone_tower1")  # Chemin vers le TileMap
const TILE_TOWER_ALLOWED = 0  # ID du tile de placement autorisé
@onready var resources_manager = get_node("/root/Main/Resources")
@onready var towers_container = get_tree().get_root().get_node("Main/Towers")


func _on_gui_input(event):
	valid_tilemap.z_index=0
	towers_container.z_index = 1
	if(resources_manager.money < tower_value):
		return
	var tempTower = tower.instantiate()
	valid_tilemap.visible=false
	if event is InputEventMouseButton and event.button_mask == 1:
		#left down 
		add_child(tempTower)
		tempTower.global_position = event.global_position
		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
	elif event is InputEventMouseButton and event.button_mask == 1:	
		#lefi up
		if get_child_count() > 1 :
			get_child(1).global_position = event.global_position
		
	elif event is InputEventMouseButton and event.button_mask == 0:
		if get_child_count() > 1 :
			get_child(1).queue_free()
			
		var path = get_tree().get_root().get_node("Main/Towers")
		if is_position_valid(event.global_position):
			path.add_child(tempTower)
			tempTower.global_position = event.global_position
			tempTower.get_node("Area").hide()
			resources_manager.remove_money(tower_value)
			resources_manager.add_towers()
		else : 
			get_child(1).queue_free()
	else:
		if get_child_count() > 1 :
			get_child(1).global_position = event.global_position
			valid_tilemap.visible=true


func is_position_valid(position: Vector2) -> bool:
	# Vérifie que le TileMap existe
	if valid_tilemap == null:
		print("TileMap non trouvé, vérifiez le chemin.")
		return false

	# Obtient la taille des cellules via le TileSet
	var local_position = valid_tilemap.to_local(position)
	var tile_position = valid_tilemap.local_to_map(local_position)
	var tile_id = valid_tilemap.get_cell_source_id(0,tile_position)
	
	return tile_id == TILE_TOWER_ALLOWED
