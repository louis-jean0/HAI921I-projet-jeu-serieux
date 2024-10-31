extends CharacterBody2D

var target: Node2D = null
var speed = 350
var pinceDamage = 5
var lifetime = 3.0  # Durée de vie en secondes

func _ready():
	# Déclenche un timer pour la durée de vie
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_lifetime_timeout"))
	add_child(timer)
	timer.start()

func _physics_process(delta: float) -> void:
	# Vérifie si le target est toujours valide
	if target and is_instance_valid(target):
		move_towards_target(delta)
	else:
		queue_free()  # Détruit le projectile si le target est invalide

func move_towards_target(delta: float) -> void:
	var target_position = target.global_position
	velocity = global_position.direction_to(target_position).normalized() * speed
	look_at(target_position)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name and is_instance_valid(body):
		body.health -= pinceDamage
		queue_free()

func _on_lifetime_timeout():
	queue_free()
