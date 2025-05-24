class_name ActivityOverlay
extends Control

signal completed
signal cancelled

const ACTIVITY_HEIGHT = 192

@export var activity_scene: PackedScene
@export var intro_tween_duration: float = 0.5
@export var exit_tween_duration: float = 0.3

var current_activity: Node2D
var offscreen_point: Vector2:
	get:
		return Vector2(size.x / 2, size.y + ACTIVITY_HEIGHT)


func _ready() -> void:
	open()


func open(which: PackedScene = activity_scene):
	assert(
		not is_instance_valid(current_activity), "Tried to open activity when one is already active"
	)
	show()
	current_activity = which.instantiate()
	current_activity.completed.connect(completed.emit)
	add_child(current_activity)
	current_activity.process_mode = Node.PROCESS_MODE_DISABLED
	var intro_tween := create_tween()
	intro_tween.set_ease(Tween.EASE_OUT)
	intro_tween.set_trans(Tween.TRANS_BACK)
	intro_tween.tween_property(current_activity, "position", size / 2, intro_tween_duration).from(
		offscreen_point
	)
	intro_tween.tween_callback(current_activity.set.bind("process_mode", Node.PROCESS_MODE_INHERIT))


func close() -> void:
	current_activity.process_mode = Node.PROCESS_MODE_DISABLED
	var exit_tween := create_tween()
	exit_tween.set_ease(Tween.EASE_IN)
	exit_tween.set_trans(Tween.TRANS_BACK)
	exit_tween.tween_property(current_activity, "position", offscreen_point, exit_tween_duration)
	exit_tween.tween_callback(cancelled.emit)
	exit_tween.tween_callback(hide)


func _on_cancel_button_pressed() -> void:
	close()
