extends Panel

@onready var turbine_dmg = preload("res://Towers/TurbineDmg.tscn")
var is_holding_turbine = false
var turbine_dmg_value = 100
@onready var resources_manager = get_node("/root/Main/Resources")
@onready var towers_container = get_tree().get_root().get_node("Main/Towers")
		
func _on_gui_input(event):
	if(resources_manager.money < turbine_dmg_value):
		return
	var tempTurbine = turbine_dmg.instantiate()
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
		path.add_child(tempTurbine)
		tempTurbine.global_position = event.global_position
		resources_manager.remove_money(turbine_dmg_value)
		is_holding_turbine = false
		show_influence_areas(false)
	else:
		if get_child_count() > 1 :
			get_child(1).global_position = event.global_position

func show_influence_areas(visible: bool) -> void:
	for tower in towers_container.get_children():
		if(tower.has_node("Area")):
			tower.get_node("Area").visible = visible
