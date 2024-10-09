extends StaticBody2D

var Pince = preload("res://pince.png")
var pinceDamage = 5
var pathName
var currTargets = []
var curr

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tower_body_entered(body: Node2D) -> void:
	if "bidon" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		for i in currTargets:
			if "Enemy" in i.name:
				tempArray.append(i)
		var currTarget = null
		for i in tempArray:
			if currTarget == null:
				currTarget = i.get_node("../")
			else:
				if i.get_parent().get_progress() > currTarget.get_progress():
					currTarget = i.get_node("../")
		curr = currTarget
		pathName = curr.get_parent().name
		var tempPince = Pince.instantiate()
		tempPince.pathName = pathName
		tempPince.pinceDamage = pinceDamage
		get_node("PinceContainer").add_child(tempPince)
		tempPince.global_position = $Aim.global_position
					
func _on_tower_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
