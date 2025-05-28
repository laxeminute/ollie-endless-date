class_name Map
extends Node2D

var _astar: AStar2D


func _ready() -> void:
	_astar = AStar2D.new()

	for i in get_child_count():
		var point = get_child(i)
		if point is PathingPoint:
			point.initialize(i)
			_astar.add_point(point.id, point.position)
		else:
			push_error("%s is not a PathingPoint" % str(point))

	for i in get_child_count():
		var point = get_child(i) as PathingPoint
		if point:
			for connection in point.connections:
				_astar.connect_points(point.id, connection.id)


func get_point_position(id: int) -> Vector2:
	return _astar.get_point_position(id)


func get_site_at_point(id: int) -> Site:
	if id >= 0 and id < get_child_count():
		return get_child(id).get_site()
	return null


func get_path_stack(start_point: int, end_point: int) -> Array[int]:
	var id_path = _astar.get_id_path(start_point, end_point)
	var stack: Array[int] = []
	for i in range(id_path.size() - 1, -1, -1):
		stack.append(id_path[i])
	return stack
