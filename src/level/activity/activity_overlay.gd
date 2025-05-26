class_name ActivityOverlay
extends Control

# TODO: prevent button clicks outside the activity from affecting the activity

signal finished(success: bool)

const ACTIVITY_HEIGHT = 192

@export var activity_scenes: Array[PackedScene]
@export var intro_tween_duration: float = 0.5
@export var exit_tween_duration: float = 0.3

var current_activity: Node2D
var offscreen_point: Vector2:
	get:
		return Vector2(size.x / 2, size.y + ACTIVITY_HEIGHT)


func open(id: int):
	if is_instance_valid(current_activity):
		push_error("Tried to open activity when one is active, overwriting old activity")
		current_activity.queue_free()
	show()
	current_activity = activity_scenes[id].instantiate()
	current_activity.completed.connect(close.bind(true))
	add_child(current_activity)

	# transition
	current_activity.process_mode = Node.PROCESS_MODE_DISABLED
	var intro_tween := create_tween()
	intro_tween.set_ease(Tween.EASE_OUT)
	intro_tween.set_trans(Tween.TRANS_BACK)
	intro_tween.tween_property(current_activity, "position", size / 2, intro_tween_duration).from(
		offscreen_point
	)
	intro_tween.tween_callback(current_activity.set.bind("process_mode", Node.PROCESS_MODE_INHERIT))


func close(success: bool) -> void:
	current_activity.process_mode = Node.PROCESS_MODE_DISABLED
	var exit_tween := create_tween()

	# transition
	exit_tween.set_ease(Tween.EASE_IN)
	exit_tween.set_trans(Tween.TRANS_BACK)
	exit_tween.tween_property(current_activity, "position", offscreen_point, exit_tween_duration)

	# cleanup
	exit_tween.tween_callback(current_activity.queue_free)
	exit_tween.tween_callback(hide)
	exit_tween.tween_callback(finished.emit.bind(success))


func _on_cancel_button_pressed() -> void:
	close(false)
