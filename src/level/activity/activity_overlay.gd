extends CanvasLayer

signal finished(success: bool)

const ACTIVITY_HEIGHT = 192
const ID_TO_INT = {
	"G1": 0,
	"G2": 1,
	"G3": 2,
	"G4": 3,
}

@export var activity_scenes: Array[PackedScene]
@export var intro_tween_duration: float = 0.5
@export var exit_tween_duration: float = 0.3

var current_activity: Node2D
var offscreen_point: Vector2:
	get:
		return Vector2(full_rect.size.x / 2, full_rect.size.y + ACTIVITY_HEIGHT)
var exit_tween: Tween

@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var full_rect: Control = $ColorRect
@onready var cancel_button: Button = %CancelButton


func open_string(id: String):
	open(ID_TO_INT[id])


func open(id: int):
	if is_instance_valid(current_activity):
		push_error("Tried to open activity when one is active, overwriting old activity")
		current_activity.queue_free()
	show()
	start_sound.play()
	current_activity = activity_scenes[id].instantiate()
	current_activity.completed.connect(close.bind(true))
	add_child(current_activity)

	# transition
	current_activity.process_mode = Node.PROCESS_MODE_DISABLED
	current_activity.position = offscreen_point
	var intro_tween := create_tween()
	intro_tween.set_ease(Tween.EASE_OUT)
	intro_tween.set_trans(Tween.TRANS_BACK)
	intro_tween.tween_property(
		current_activity, "position", full_rect.size / 2, intro_tween_duration
	)
	intro_tween.tween_callback(current_activity.set.bind("process_mode", Node.PROCESS_MODE_INHERIT))
	intro_tween.tween_callback(cancel_button.show)


func close(success: bool) -> void:
	if exit_tween:
		if exit_tween.is_running():
			return
	if success:
		win_sound.play()
	cancel_button.hide()
	current_activity.process_mode = Node.PROCESS_MODE_DISABLED
	exit_tween = create_tween()

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
