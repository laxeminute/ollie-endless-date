class_name Site
extends Area2D

const DIALOG_ALPHA_ON_RECOMMENDED = 1.0
const DIALOG_ALPHA_ON_NOT_RECOMMENDED = 0.4

var location_id: int
var actor: Actor = null
@onready var glow: Sprite2D = $Glow
@onready var dialog: Control = $Dialog


func on_actor_arriving(p_actor: Actor) -> void:
	actor = p_actor


func on_actor_leaving() -> void:
	actor = null


func recommend_visit(is_recommended: bool) -> void:
	if is_recommended:
		dialog.modulate = Color(1.0, 1.0, 1.0, DIALOG_ALPHA_ON_RECOMMENDED)
	else:
		dialog.modulate = Color(1.0, 1.0, 1.0, DIALOG_ALPHA_ON_NOT_RECOMMENDED)


func _on_mouse_entered() -> void:
	if ActivityOverlay.visible:
		return
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(glow, "modulate", Color.WHITE, 0.3)


func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(glow, "modulate", Color.TRANSPARENT, 0.3)
