extends StaticBody2D

# x2 car bug de double détection !!
var max_destroy_count = 20 # Nombre maximal d'objets à supprimer avant la destruction 
var cpt = 0  # Compteur pour le nombre d'objets supprimés
var currTarget : Node2D = null
@onready var resources_manager = get_node("/root/Main/Resources")

func _ready() -> void:
	# Connecter le signal de détection de collision en utilisant un Callable
	currTarget = find_closest_target()
	
func _process(delta: float) -> void:
	currTarget = find_closest_target()
	if currTarget != null:
		if("Enemy" in currTarget.name):
			currTarget.health = 0
			cpt += 1  # Incrémenter le compteur
			resources_manager.add_qqt()
		
		# Vérifier si le filet a atteint la limite d'objets détruits
		if cpt >= max_destroy_count:
			queue_free()  # Supprime le filet lui-même



func find_closest_target() -> Node2D:
	var farthest_target: Node2D = null
	var farthest_distance = -INF
	var overlapping_bodies = $Tower.get_overlapping_bodies()
	for body in overlapping_bodies:
		if "Enemy" in body.name:
			var distance = global_position.distance_to(body.global_position)
			if distance > farthest_distance:
				farthest_distance = distance
				farthest_target = body

	return farthest_target
