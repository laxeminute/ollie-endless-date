extends Node2D

signal completed

const HEIGHT = 192
const WIDTH = 192
const HALF_HEIGHT = HEIGHT / 2.0
const HALF_WIDTH = WIDTH / 2.0

@onready var catcher: Catcher = $Catcher


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("activity_action"):
		_catch()


func _process(_delta: float) -> void:
	if catcher.catching:
		return
	# TODO: position smoothing
	catcher.position = get_local_mouse_position().clamp(
		Vector2(-HALF_WIDTH + catcher.radius, -HALF_HEIGHT + catcher.radius),
		Vector2(HALF_WIDTH - catcher.radius, HALF_HEIGHT - catcher.radius)
	)


func _catch() -> void:
	if catcher.catching:
		return
	var caught = await catcher.catch()
	if caught:
		completed.emit()
