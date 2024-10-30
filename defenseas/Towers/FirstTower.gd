extends StaticBody2D

const Pince = preload("res://Towers/pince.tscn")
var pinceDamage = 5
var time_between_shots = 1.5
var shoot_timer: Timer
var currTarget : Node2D = null

func _ready() -> void:
	# Créer et configurer le timer
	shoot_timer = Timer.new()
	shoot_timer.wait_time = time_between_shots 
	shoot_timer.one_shot = false
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))
	add_child(shoot_timer)
	shoot_timer.start()
	currTarget = find_closest_target()

func _process(delta: float) -> void:
	currTarget = find_closest_target()
	if currTarget == null:
		clear_pincers()

func find_closest_target() -> Node2D:
	var farthest_target: Node2D = null
	var farthest_distance = -INF
	var overlapping_bodies = $Tower.get_overlapping_bodies()
	for body in overlapping_bodies:
		if "Enemy" in body.name:
			var distance = body.get_parent().get_progress()
			if distance > farthest_distance:
				farthest_distance = distance
				farthest_target = body.get_parent()
	return farthest_target
	
func _on_turbine_entered(body: Node) -> void:
	if body.has_method("_type"):
		if body.type == "damage":
			print("TurbineDmg détectée :", body.name)
			pinceDamage += body.damage_bonus
			print("Bonus de dégâts ajouté :", body.damage_bonus)
		elif body.type == "rof":
			print("TurbineRof détectée :", body.name)
			time_between_shots -= body.rof_bonus
			shoot_timer.wait_time = time_between_shots
			shoot_timer.start()
			print("Vitesse de tir ajustée à :", time_between_shots)
		
func _on_turbine_exited(body: Node) -> void:
	if body is Area2D and body.has_method("_type"):
		if body.type == "damage":
			print("TurbineDmg détectée :", body.name)
			pinceDamage -= body.damage_bonus
			print("Bonus de dégâts ajouté :", body.damage_bonus)
		
		elif body.type == "rof":
			print("TurbineRof détectée :", body.name)
			time_between_shots = 0.5
			print("Vitesse de tir ajustée à :", time_between_shots)

func _on_shoot_timer_timeout() -> void:
	if currTarget != null and is_instance_valid(currTarget):
		spawn_pincer(currTarget)

func spawn_pincer(target: Node2D) -> void:
	var tempPince = Pince.instantiate()
	tempPince.target = target
	tempPince.pinceDamage = pinceDamage
	tempPince.global_position = $Aim.global_position
	get_node("PinceContainer").call_deferred("add_child", tempPince)

func clear_pincers() -> void:
	for pincer in get_node("PinceContainer").get_children():
		pincer.queue_free()
