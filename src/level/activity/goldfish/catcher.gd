class_name Catcher
extends Area2D

signal caught_fish

@export var catch_duration: float = 0.7

var radius: float:
	get:
		return $CollisionShape2D.shape.radius
var catching: bool = false


func catch() -> void:
	if catching:
		return
	catching = true
	$AudioStreamPlayer.play()
	z_index = 0
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", Color.WHITE, catch_duration).from(
		Color(Color.WHITE, 0.3)
	)
	await tween.finished
	z_index = 1
	catching = false
	if has_overlapping_areas():
		caught_fish.emit()
