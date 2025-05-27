class_name Handle
extends Node2D

signal revolved

@export_enum("Clockwise:1", "Counter-Clockwise:-1") var direction: int = 1

var active: bool = false
var progress: float = 0


func _process(_delta: float) -> void:
	if not active:
		return
	var pre_rotation: float = rotation
	look_at(get_global_mouse_position())
	var dtheta: float = rotation - pre_rotation
	progress += dtheta * direction

	if progress > TAU:
		progress -= TAU
		revolved.emit()
	if progress < -TAU:
		progress += TAU
