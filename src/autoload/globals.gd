extends Node

signal leave_counted_down
const SITE_COLLISION_LAYER = 1


func exp_decay(from: Variant, to: Variant, dt: float, decay: float = 16):
	## Used for framerate-independent smoothing.
	if typeof(from) != typeof(to):
		push_error("Types mismatched for source and destination")
		return null
	if from is float:
		return to + (from - to) * exp(-decay * dt)
	if from is Vector2:
		return Vector2(exp_decay(from.x, to.x, dt, decay), exp_decay(from.y, to.y, dt, decay))
