extends Node2D

signal completed

const HEIGHT = 192
const WIDTH = 192
const HALF_HEIGHT = HEIGHT / 2.0
const HALF_WIDTH = WIDTH / 2.0

@onready var catcher: Area2D = $Catcher
@onready var catcher_radius: float = $Catcher/CollisionShape2D.shape.radius


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("activity_action"):
		_catch()


func _process(_delta: float) -> void:
	catcher.position = get_local_mouse_position().clamp(
		Vector2(-HALF_WIDTH + catcher_radius, -HALF_HEIGHT + catcher_radius),
		Vector2(HALF_WIDTH - catcher_radius, HALF_HEIGHT - catcher_radius)
	)


func _catch() -> void:
	# if catcher is catching return
	await catcher.catch()
	if catcher.has_overlapping_areas():
		completed.emit()
