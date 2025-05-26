class_name Catcher
extends Area2D

var radius: float:
	get:
		return $CollisionShape2D.shape.radius
var catching: bool = false


func catch() -> bool:
	catching = true
	# TODO: play sound
	await get_tree().create_timer(0.7).timeout  # TODO: replace with animation
	catching = false
	return has_overlapping_areas()
