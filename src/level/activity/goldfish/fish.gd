extends Area2D

@export var pool_radius: float = 96.0
@export var swim_duration: float = 0.8
@export var swim_variance: float = 0.2
@export var maximum_distance: float = 80

var tween: Tween


func _ready() -> void:
	# Desync all fishes from each other
	await get_tree().create_timer(swim_duration * randf()).timeout
	_swim()


func _swim() -> void:
	if tween:
		if tween.is_running():
			return
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	var target_position: Vector2 = _get_random_position()
	while target_position.distance_to(position) > maximum_distance:
		target_position = _get_random_position()
	look_at(target_position)
	tween.tween_property(self, "position", target_position, swim_duration + swim_variance * randf())
	tween.finished.connect(_swim)


func _get_random_position() -> Vector2:
	# WARN: only gets a position within a circle, maybe rework to a box
	var target_position := Vector2.RIGHT.rotated(TAU * randf())
	target_position *= pool_radius * randf()
	return target_position
