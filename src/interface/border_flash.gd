@tool
class_name BorderFlash
extends Control

@export_tool_button("Reset") var reset_button = func() -> void: modulate = Color.WHITE
@export_tool_button("Flash") var flash_button = flash

@export_range(0, 48, 1, "suffix:px") var thickness: float = 16.0:
	set(value):
		thickness = value
		if not is_node_ready():
			await ready
		top.offset_bottom = thickness
		bottom.offset_top = -thickness
		left.offset_right = thickness
		right.offset_left = -thickness

@onready var top: Control = $Top
@onready var bottom: Control = $Bottom
@onready var left: Control = $Left
@onready var right: Control = $Right


func flash(duration: float = 0.5, color: Color = Color.RED) -> void:
	var alpha_tween := create_tween()
	alpha_tween.set_trans(Tween.TRANS_QUAD)
	alpha_tween.tween_property(self, "modulate", Color(color, 0), duration).from(color)
