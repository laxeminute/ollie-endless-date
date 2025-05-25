class_name Site
extends Area2D

var location_id: int
var is_actor_present: bool

func on_actor_arriving() -> void:
	is_actor_present = true


func on_actor_leaving() -> void:
	is_actor_present = false
