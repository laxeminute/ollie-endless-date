class_name RingNumber
extends Area2D

signal clicked(number: int)

const DIMENSIONS = Vector2i(48, 48)

@onready var sprite: Sprite2D = $Sprite2D

var number: int:
	set(value):
		if value < 1 or value > 9:
			push_error("Number should be an integer 1-9")
			return
		number = value
		var zero_indexed: int = number - 1
		@warning_ignore("INTEGER_DIVISION")
		sprite.region_rect.position = Vector2(
			DIMENSIONS.x * (zero_indexed % 3), DIMENSIONS.y * (zero_indexed / 3)
		)
