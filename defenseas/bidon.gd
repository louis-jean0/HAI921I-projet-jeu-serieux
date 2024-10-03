# Script de l'objet
extends Node2D

@export var path_follow : PathFollow2D  # Référence à PathFollow2D

var speed = 100  # Vitesse de déplacement

func _process(delta):
	if path_follow:
		path_follow.h_offset+=speed*delta
		position = path_follow.position  # Met à jour la position de l'objet
