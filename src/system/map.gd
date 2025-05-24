class_name Map
extends Node2D

var _astar: AStar2D

func _ready() -> void:
	_astar = AStar2D.new()
	
	for i in get_child_count():
		var point = get_child(i) as PathingPoint
		if point:
			point.initialize(i)
			_astar.add_point(point.id, point.position)
	
	for i in get_child_count():
		var point = get_child(i) as PathingPoint
		if point:
			for connection in point.connections:
				_astar.connect_points(point.id, connection.id)


func get_point_position(id: int) -> Vector2:
	return _astar.get_point_position(id)


func get_point_stack(start_point: int, end_point: int) -> Array[int]:
	var id_path = _astar.get_id_path(start_point, end_point)
	var stack: Array[int] = []
	for i in range(id_path.size()-1, -1, -1):
		stack.append(id_path[i])
	return stack
