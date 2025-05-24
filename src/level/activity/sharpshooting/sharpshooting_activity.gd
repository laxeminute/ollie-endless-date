extends Node2D

signal completed

const WIDTH = 192
const HEIGHT = 192
const HALF_WIDTH = WIDTH / 2.0
const HALF_HEIGHT = HEIGHT / 2.0

@export var aim_duration := Vector2.ONE
@export var aim_tween_ease := Tween.EaseType.EASE_IN_OUT
@export var aim_tween_transition := Tween.TransitionType.TRANS_SINE
@export var targets_shown: int = 4

var tween_y: Tween
var tween_x: Tween

@onready var targets: Node = $Targets
@onready var aim_y: Line2D = $AimY
@onready var aim_x: Line2D = $AimX
@onready var crosshair: Area2D = $Crosshair


func _ready() -> void:
	reset()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("activity_action"):
		return
	if tween_y.is_running():
		tween_y.kill()  # lock vertical in place
		_setup_tween_x()
	elif tween_x.is_running():
		tween_x.kill()
		_fire()


func _process(_delta: float) -> void:
	crosshair.position = Vector2(aim_x.position.x, aim_y.position.y)


func reset() -> void:
	_setup_targets()
	aim_y.position = Vector2.ZERO
	aim_x.position = Vector2.ZERO
	_setup_tween_y()
	aim_x.hide()


func _fire() -> void:
	# TODO: animation?
	await get_tree().create_timer(0.5).timeout
	if crosshair.has_overlapping_areas():
		completed.emit()
	else:
		reset()


func _setup_targets() -> void:
	## All possible spawn locations are Targets in the scene.
	## We randomly hide some, leaving `targets_shown` visible.
	var total_targets := targets.get_child_count()
	assert(total_targets >= targets_shown)
	var shown_ids := Array(range(total_targets))
	shown_ids.shuffle()
	shown_ids = shown_ids.slice(0, targets_shown)
	for i in total_targets:
		var target_i := targets.get_child(i) as Area2D
		if i in shown_ids:
			target_i.show()
			target_i.monitorable = true
		else:
			target_i.hide()
			target_i.monitorable = false


func _setup_tween_y() -> void:
	aim_y.position = HALF_HEIGHT * Vector2.UP
	aim_y.show()
	tween_y = create_tween()
	tween_y.set_loops()
	tween_y.set_ease(aim_tween_ease)
	tween_y.set_trans(aim_tween_transition)
	tween_y.tween_property(aim_y, "position", HALF_HEIGHT * Vector2.DOWN, aim_duration.y)
	tween_y.tween_property(aim_y, "position", HALF_HEIGHT * Vector2.UP, aim_duration.y)
	tween_y.custom_step(aim_duration.y / 2.0)


func _setup_tween_x() -> void:
	aim_x.position = HALF_WIDTH * Vector2.LEFT
	aim_x.show()
	tween_x = create_tween()
	tween_x.set_loops()
	tween_x.set_ease(aim_tween_ease)
	tween_x.set_trans(aim_tween_transition)
	tween_x.tween_property(aim_x, "position", HALF_WIDTH * Vector2.RIGHT, aim_duration.x)
	tween_x.tween_property(aim_x, "position", HALF_WIDTH * Vector2.LEFT, aim_duration.x)
	tween_x.custom_step(aim_duration.x / 2.0)
