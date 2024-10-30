extends Control

@onready var stats = $Panel/Msg/MsgLabel
@onready var morale = $Panel/Morale
@onready var total_enemies = get_parent().get_node("PathSpawner").total_enemies
var enemies_killed = 0
var enemies_passed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies_passed = get_parent().get_node("LevelContainer").get_child(0).get_node("EndZone").enemy_count
	enemies_killed = total_enemies - enemies_passed
	display_end_phrases()
	pass

var morale_phrases = [
	"Chaque année, environ 8 millions de tonnes de plastique finissent dans nos océans.",
	"Environ 100 millions d'animaux marins meurent chaque année à cause de la pollution.",
	"Environ 50 % des récifs coralliens dans le monde ont été perdus au cours des 30 dernières années.",
	"Plus de 1 million d'espèces marines sont actuellement menacées d'extinction.",
	"Il existe plus de 400 zones mortes dans les océans, des régions où le niveau d'oxygène est trop bas pour soutenir la vie marine.",
	"La biodiversité marine a diminué de 39 % en moyenne depuis 1970."
]

func display_end_phrases() -> void:
	stats.bbcode_text = "[center]En ramassant " + str(enemies_killed) + " déchets, vous avez protégé l'océan de la pollution.\n\nVotre détermination a fait la différence ! 🌊\n\nCependant, restez conscients que " + str(enemies_passed) + " déchets sont tout de même passés pour se jeter dans notre bel océan.\n\nNe lâchez pas la lutte ![/center]"
	
func display_moral() -> void:
	var shuffled_phrases = morale_phrases.duplicate()
	shuffled_phrases.shuffle()
	var selected_phrase = shuffled_phrases[0]
	morale.bbcode_text = "[center][b][i]" + selected_phrase + "[/i][/b][/center]"

func _on_rejouer_pressed() -> void:
	var menu_scene = preload("res://Scene/menu.tscn")
	get_tree().change_scene_to_packed(menu_scene)
