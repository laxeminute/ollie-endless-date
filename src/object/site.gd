class_name Site
extends Area2D

const DIALOG_ALPHA_ON_RECOMMENDED = 1.0
const DIALOG_ALPHA_ON_NOT_RECOMMENDED = 0.4
var location_id: int
var actor: Actor = null
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
