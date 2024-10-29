extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var icon1 = preload("res://miscellaneous/pause1.png")
	$Panel/Pause.icon = icon1
	var icon2 = preload("res://miscellaneous/pause2.png")
	$Panel/Resume.icon = icon2
	$Panel/Pause.show()
	$Panel/Resume.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pause_pressed() -> void:
	$Panel/Pause.hide()
	$Panel/Resume.show()
	get_tree().paused = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	
func _on_resume_pressed() -> void:
	$Panel/Resume.hide()
	$Panel/Pause.show()
	get_tree().paused = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func _on_fermer_menu_pressed() -> void:
	var sous_menu = $BoxOptions
	sous_menu.visible = !sous_menu.visible

func _on_menu_principal_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	
func _on_volume_changed(value) -> void:
	var volume_db = linear_to_db(value / 10.0)  # Convertit une valeur linéaire en dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
