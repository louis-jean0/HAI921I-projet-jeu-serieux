extends Panel

@onready var filet = preload("res://Towers/filet.tscn")
var filet_value = 200
@onready var resources_manager = get_node("/root/Main/Resources")
@onready var valid_tilemap = get_tree().get_root().get_node("Main/Zone_tower4")  # Chemin vers le TileMap
const TILE_TOWER_ALLOWED = 0  # ID du tile de placement autorisé

func _on_gui_input(event):
	if(resources_manager.money < filet_value):
		return
	var tempFilet = filet.instantiate()
	valid_tilemap.visible=false
	if event is InputEventMouseButton and event.button_mask == 1:
		#left down 
		add_child(tempFilet)
		tempFilet.global_position = event.global_position
		tempFilet.process_mode = Node.PROCESS_MODE_DISABLED
	elif event is InputEventMouseButton and event.button_mask == 1:	
		#lefi up
		if get_child_count() > 1 :
			get_child(1).global_position = event.global_position
		
	elif event is InputEventMouseButton and event.button_mask == 0:
		if get_child_count() > 1 :
			get_child(1).queue_free()
			
		var path = get_tree().get_root().get_node("Main/Towers")
		if is_position_valid(event.global_position):
			path.add_child(tempFilet)
			tempFilet.global_position = event.global_position
			tempFilet.get_node("Area").hide()
			resources_manager.remove_money(filet_value)
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
