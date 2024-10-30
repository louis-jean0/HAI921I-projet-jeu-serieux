extends Node2D

func getWasteGrid():
	return get_tree().get_root().get_node("World/wasteGrid").listOfWaste

func waste_fall_in_sea(type_waste):
	var new_waste = Waste.new()
	new_waste.type = type_waste
	new_waste.sprite.position = Vector2(360+randi()%(12*128),580)
	new_waste.sprite.texture = Waste.texture_paths[type_waste]
	get_tree().get_root().get_node("World/PlayerBoat").addWasteInFalling(new_waste)
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
