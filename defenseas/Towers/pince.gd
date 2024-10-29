extends CharacterBody2D

var target: Node2D = null
var speed = 350
var pinceDamage = 5  # Assurez-vous que la valeur est correctement assignée

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		move_towards_target(delta)
	else:
		queue_free()

func move_towards_target(delta: float) -> void:
	if(not is_instance_valid(target)):
		queue_free()
	var target_position = target.global_position
	velocity = global_position.direction_to(target_position).normalized() * speed
	look_at(target_position)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		body.health -= pinceDamage
		queue_free()
