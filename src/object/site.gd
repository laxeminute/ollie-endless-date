class_name Site
extends Area2D

var location_id: int
var actor: Actor = null


func on_actor_arriving(p_actor: Actor) -> void:
	actor = p_actor


func on_actor_leaving() -> void:
	actor = null
