extends Node2D

signal completed

@export_range(1, 4) var min_spins: int = 1
@export_range(1, 12) var spin_count_variance: int = 4

var active: bool = true
var spin_progress: int = 0
var spin_goal: int

@onready var handle: Handle = $Handle
# TODO: replace this sound stream
@onready var marble_sound: AudioStreamPlayer = $MarbleSound


func _ready() -> void:
	spin_goal = min_spins + randi_range(0, spin_count_variance)
	handle.look_at(get_global_mouse_position())


func _on_handle_revolved() -> void:
	marble_sound.play()
	spin_progress += 1
	if spin_progress < spin_goal:
		return
	active = false
	handle.active = false
	await get_tree().create_timer(0.5).timeout  # TODO: play animation
	completed.emit()


func _on_mouse_detector_mouse_entered() -> void:
	handle.active = active


func _on_mouse_detector_mouse_exited() -> void:
	handle.active = false
