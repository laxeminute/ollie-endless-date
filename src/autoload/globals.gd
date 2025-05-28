extends Node

@warning_ignore("unused_signal")
signal leave_counted_down
@warning_ignore("unused_signal")
signal wrong_food_given
@warning_ignore("unused_signal")
signal activity_canceled
@warning_ignore("unused_signal")
signal minigame_mode_enabled(enabled: bool)

const SITE_COLLISION_LAYER = 2

const PARTNERS = ["P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8"]
const FOOD_REQUESTS = ["F1", "F2", "F3", "F4"]
const NUM_OF_FOOD = 4
const GAME_REQUESTS = ["G1", "G2", "G3", "G4"]
const NUM_OF_GAME = 4
const ITEMS = ["I1", "I2"]
const NUM_OF_ITEM = 2

const Icons = {
	"F1": preload("res://assets/sprite/request_food_1.atlastex"),
	"F2": preload("res://assets/sprite/request_food_2.atlastex"),
	"F3": preload("res://assets/sprite/request_food_3.atlastex"),
	"F4": preload("res://assets/sprite/request_food_4.atlastex"),
	"G1": preload("res://assets/sprite/request_game_1.atlastex"),
	"G2": preload("res://assets/sprite/request_game_2.atlastex"),
	"G3": preload("res://assets/sprite/request_game_3.atlastex"),
	"G4": preload("res://assets/sprite/request_game_4.atlastex"),
	"I1": preload("res://assets/sprite/item_1.atlastex"),
	"I2": preload("res://assets/sprite/item_2.atlastex"),
	"P1": preload("res://assets/sprite/partner_1.atlastex"),
	"P2": preload("res://assets/sprite/partner_2.atlastex"),
	"P3": preload("res://assets/sprite/partner_3.atlastex"),
	"P4": preload("res://assets/sprite/partner_4.atlastex"),
	"P5": preload("res://assets/sprite/partner_5.atlastex"),
	"P6": preload("res://assets/sprite/partner_6.atlastex"),
	"P7": preload("res://assets/sprite/partner_7.atlastex"),
	"P8": preload("res://assets/sprite/partner_8.atlastex"),
}

const PREFERENCES = {
	"P1": "I1",
	"P2": "I1",
	"P3": "I1",
	"P4": "I1",
	"P5": "I2",
	"P6": "I2",
	"P7": "I2",
	"P8": "I2",
}


func exp_decay(from: Variant, to: Variant, dt: float, decay: float = 16):
	## Used for framerate-independent smoothing.
	if typeof(from) != typeof(to):
		push_error("Types mismatched for source and destination")
		return null
	if from is float:
		return to + (from - to) * exp(-decay * dt)
	if from is Vector2:
		return Vector2(exp_decay(from.x, to.x, dt, decay), exp_decay(from.y, to.y, dt, decay))
