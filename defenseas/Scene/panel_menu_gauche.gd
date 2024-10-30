extends Control

var first_tower_instance: Node = null

var script_tower=load("res://Towers/FirstTower.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var icon1 = preload("res://miscellaneous/pause1.png")
	$Panel/Pause.icon = icon1
	var icon2 = preload("res://miscellaneous/pause2.png")
	$Panel/Resume.icon = icon2
	$Panel/Pause.show()
	$Panel/Resume.hide()
	
	$BoxOptions/Label/Volume.set_value_no_signal(Global.sound)
	_on_volume_value_changed(Global.sound)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BoxOptions/Label/Volume.set_value_no_signal(Global.sound)
	_on_volume_value_changed(Global.sound)

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
	var sous_menu2 = $BoxOptions2
	sous_menu.visible = !sous_menu.visible
	sous_menu2.visible = !sous_menu2.visible

func _on_menu_principal_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	
func _on_volume_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value / 10.0)  # Convertit une valeur linéaire en dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
	Global.sound=value


func _on_check_box_pressed() -> void:
	script_tower.changed_sound()
