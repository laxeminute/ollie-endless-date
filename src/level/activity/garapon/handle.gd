class_name Handle
extends Node2D

signal revolved

@export_enum("Clockwise:1", "Counter-Clockwise:-1") var direction: int = 1

var active: bool = false
var progress: float = 0

@onready var last_rotation: float = rotation


func _process(_delta: float) -> void:
	if not active:
		return
	look_at(get_global_mouse_position())


func _physics_process(_delta: float) -> void:
	if not active:
		return
	look_at(get_global_mouse_position())
	progress += direction * (rotation - last_rotation)
	last_rotation = rotation

	if progress > TAU:
		progress -= TAU
		revolved.emit()
	if progress < -TAU:
		progress += TAU
