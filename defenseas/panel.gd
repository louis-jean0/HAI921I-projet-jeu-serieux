extends Panel

var pause=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_pressed() -> void:
	var icon1 = preload("res://pause1.png")
	var icon2 = preload("res://pause2.png")
	pause=!pause
	if(pause): $Pause.icon = icon1
	else : $Pause.icon = icon2
	
	
func _on_volume_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value / 100.0)  # Convertit une valeur linéaire en dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)


func _on_fermer_menu_pressed() -> void:
	var sous_menu = $BoxOptions
	sous_menu.visible = !sous_menu.visible
