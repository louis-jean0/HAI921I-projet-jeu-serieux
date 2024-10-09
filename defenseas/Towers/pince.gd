extends CharacterBody2D

var target
var speed = 1000
var pathName = ""
var pinceDamage

func _physics_process(delta: float) -> void:
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	for i in range(0,pathSpawnerNode.get_child_count()):
		if pathSpawnerNode.get_child(i).name == pathName:
			target = pathSpawnerNode.get_child(i).get_child(0).get_child(0).global_position
	velocity = global_position.direction_to(target) * speed
	look_at(target)
	move_and_slide()
	pass
