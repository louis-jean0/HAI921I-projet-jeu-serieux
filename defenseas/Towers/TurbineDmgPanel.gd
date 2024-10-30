extends Panel

@onready var turbine_dmg = preload("res://Towers/TurbineDmg.tscn")
var is_holding_turbine = false
var turbine_dmg_value = 100
@onready var resources_manager = get_node("/root/Main/Resources")
@onready var towers_container = get_tree().get_root().get_node("Main/Towers")

@onready var valid_tilemap = get_tree().get_root().get_node("Main/Zone_tower4")  # Chemin vers le TileMap
const TILE_TOWER_ALLOWED = 0  # ID du tile de placement autorisé
		
func _on_gui_input(event):
	valid_tilemap.z_index=0
	towers_container.z_index = 1
	if(resources_manager.money < turbine_dmg_value):
		return
	var tempTurbine = turbine_dmg.instantiate()
	valid_tilemap.visible=false
	if event is InputEventMouseButton and event.button_mask == 1:
		#left down
		add_child(tempTurbine)
		tempTurbine.global_position = event.global_position
		tempTurbine.process_mode = Node.PROCESS_MODE_DISABLED
		is_holding_turbine = true
		show_influence_areas(true)
	elif event is InputEventMouseButton and event.button_mask == 1:	
		#lefi up
		is_holding_turbine = false
		show_influence_areas(false)
		if get_child_count() > 1 :
			get_child(1).global_position = event.global_position
		
	elif event is InputEventMouseButton and event.button_mask == 0:
		
		if get_child_count() > 1 :
			get_child(1).queue_free()
		var path = get_tree().get_root().get_node("Main/Towers")		
		if is_position_valid(event.global_position):
			path.add_child(tempTurbine)
			tempTurbine.global_position = event.global_position
			resources_manager.remove_money(turbine_dmg_value)
			resources_manager.add_turbines()
			is_holding_turbine = false
			show_influence_areas(false)
	else:
		if get_child_count() > 1 :
			get_child(1).global_position = event.global_position
			valid_tilemap.visible=true

func show_influence_areas(visible: bool) -> void:
	for tower in towers_container.get_children():
		if(tower.has_node("Area")):
			tower.get_node("Area").visible = visible
			
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
