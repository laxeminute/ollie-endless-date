class_name PathingPoint
extends Node2D

var id: int
@export var connections: Array[PathingPoint] = []


func initialize(p_id: int) -> void:
	id = p_id
	var site := get_site()
	if site:
		site.location_id = id


func get_site() -> Site:
	if get_child_count() > 0:
		var child = get_child(0) as Site
		return child
	else:
		return null
