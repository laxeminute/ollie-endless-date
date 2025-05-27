class_name RingNumber
extends Area2D

signal clicked(number: int)

const DIMENSIONS = Vector2i(48, 48)

var active: bool = true

@onready var number_sprite: Sprite2D = $Number
@onready var ring: Sprite2D = $Ring

var number: int:
	set(value):
		if value < 1 or value > 9:
			push_error("Number should be an integer 1-9")
			return
		number = value
		var zero_indexed: int = number - 1
		@warning_ignore("INTEGER_DIVISION")
		number_sprite.region_rect.position = Vector2(
			DIMENSIONS.x * (zero_indexed % 3), DIMENSIONS.y * (zero_indexed / 3)
		)


func reset() -> void:
	active = true
	ring.hide()
	ring.modulate = Color(Color.WHITE, 0.5)


func _on_click_detector_clicked() -> void:
	if not active:
		return
	clicked.emit(number)
	ring.modulate = Color.WHITE
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(ring, "scale", Vector2.ONE, 0.3).from(2 * Vector2.ONE)


func _on_mouse_entered() -> void:
	if not active:
		return
	ring.show()


func _on_mouse_exited() -> void:
	if not active:
		return
	ring.hide()
