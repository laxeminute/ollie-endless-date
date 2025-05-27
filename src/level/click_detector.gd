class_name ClickDetector
extends Node

signal clicked

@export var area: Area2D
@export var click_mask: MouseButtonMask = MOUSE_BUTTON_MASK_LEFT


func _ready() -> void:
	area.input_event.connect(_on_area_input_event)


func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_input := event as InputEventMouseButton
	if not mouse_input:
		return
	if not mouse_input.pressed:
		return
	if not mouse_input.button_mask == click_mask:
		return
	clicked.emit()
