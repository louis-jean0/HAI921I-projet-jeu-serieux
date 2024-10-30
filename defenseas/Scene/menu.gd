extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BoxMenu/LancerPartie.grab_focus()
	$BoxOptions/Label/Volume.set_value_no_signal(Global.sound)
	_on_volume_value_changed(Global.sound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BoxOptions/Label/Volume.set_value_no_signal(Global.sound)
	_on_volume_value_changed(Global.sound)

func _on_lancer_partie_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main.tscn")
	
func _on_comment_jouer_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/CommentJouer.tscn")
	
func _on_options_pressed() -> void:
	var menu = $BoxMenu
	menu.visible = !menu.visible
	var sous_menu = $BoxOptions
	sous_menu.visible = !sous_menu.visible

func _on_fermer_pressed() -> void:
	get_tree().quit()

func _on_fermer_menu_pressed() -> void:
	var menu = $BoxMenu
	menu.visible = !menu.visible
	var sous_menu = $BoxOptions
	sous_menu.visible = !sous_menu.visible

func _on_volume_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value / 30.0)  # Convertit une valeur linéaire en dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
	Global.sound=value
