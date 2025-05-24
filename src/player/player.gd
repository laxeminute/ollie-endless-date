class_name Player
extends Node2D

@export var move_speed: float = 200.0

var current_path: Array[int]
var current_point: int

var _map: Map
var _currently_move_toward: Vector2

func initialize(map: Map, starting_point: int) -> void:
	_map = map
	current_path = []
	current_point = starting_point
	_currently_move_toward = _map.get_point_position(starting_point)
	show()


func _process(delta: float) -> void:
	if position.distance_to(_currently_move_toward) > 1.0:
		position = position.move_toward(_currently_move_toward, move_speed * delta)
	else:
		# try getting new current_point
		var next_point = current_path.pop_back()
		if next_point != null:
			current_point = next_point
			_currently_move_toward = _map.get_point_position(current_point)


func move_to(end_point: int) -> void:
	current_path = _map.get_point_stack(current_point, end_point)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var site = _get_selected_site()
			if site:
				move_to(site.point_id)


func _get_selected_site() -> Site:
	var mouse_pos = get_global_mouse_position()
	var space = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = mouse_pos
	params.collision_mask = Globals.SITE_COLLISION_LAYER
	params.collide_with_bodies = false
	params.collide_with_areas = true
	
	var areas = space.intersect_point(params, 4)
	var site: Site = null
	for i in areas.size():
		site = areas[i].collider as Site
		if site:
			break
	
	return site
