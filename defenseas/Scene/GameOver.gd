extends Control

@onready var stats = $Panel/Stats/StatsLabel
@onready var morale = $Panel/Morale

var phrases = [
	"Vous avez asphyxié 49 tortues de mer.",
	"À cause de votre inaction, 27 dauphins et baleines se sont échoués sur les plages.",
	"Les poissons se battent pour respirer.",
	"À cause de votre performance, 148 kilogrammes de déchets plastiques ont été ajoutés à nos océans.",
	"10 kilomètres carrés de coraux sont morts à cause de la pollution.",
	"Votre échec a provoqué la disparition de nombreuses espèces marines.",
	"Les dauphins ne peuvent plus nager dans des eaux propres."
]

var morale_phrases = [
	"Chaque année, environ 8 millions de tonnes de plastique finissent dans nos océans.",
	"Environ 100 millions d'animaux marins meurent chaque année à cause de la pollution.",
	"Environ 50 % des récifs coralliens dans le monde ont été perdus au cours des 30 dernières années.",
	"Plus de 1 million d'espèces marines sont actuellement menacées d'extinction.",
	"Il existe plus de 400 zones mortes dans les océans, des régions où le niveau d'oxygène est trop bas pour soutenir la vie marine.",
	"La biodiversité marine a diminué de 39 % en moyenne depuis 1970."
]

func display_end_phrases() -> void:
	var shuffled_phrases = phrases.duplicate()
	shuffled_phrases.shuffle()
	var number_of_phrases_to_show = min(4, shuffled_phrases.size())
	var selected_phrases = shuffled_phrases.slice(0, number_of_phrases_to_show)
	stats.text = "\n".join(selected_phrases)
	
func display_moral() -> void:
	var shuffled_phrases = morale_phrases.duplicate()
	shuffled_phrases.shuffle()
	var selected_phrase = shuffled_phrases[0]
	morale.bbcode_text = "[center][b][i]" + selected_phrase + "[/i][/b][/center]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_end_phrases()
	display_moral()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_rejouer_pressed() -> void:
	var menu_scene = preload("res://Scene/menu.tscn")
	get_tree().change_scene_to_packed(menu_scene)
