extends Site

const MAX_ENJOYMENT = 50.0
const MAX_VISIBLE_ENJOYMENT = 40.0
const LEAVE_WAIT_COUNT = 5.0

@export var enjoyment_decrease_rate: float = 1.0
@export var enjoyment_increase_rate: float = 4.0
@export var request_cooldown_on_arrival: float = 2.0
@export var request_cooldown: float = 10.0

var current_enjoyment: float
var is_wanting_to_leave: bool
var leave_countdown: float

var _request_counter: float
var _leave_sec_counter: float

@onready var partner_sprite: Sprite2D = $PartnerSprite
@onready var enjoyment_bar: ProgressBar = $EnjoymentBar
@onready var leave_bar: TextureProgressBar = $LeaveBar
@onready var thought_bubble: Node2D = $ThoughtBubble

func _ready() -> void:
	leave()
	enjoyment_bar.max_value = MAX_VISIBLE_ENJOYMENT
	leave_bar.max_value = LEAVE_WAIT_COUNT


func _process(delta: float) -> void:
	_update_enjoyment(delta)
	enjoyment_bar.value = current_enjoyment


func arrive() -> void:
	partner_sprite.show()
	enjoyment_bar.show()
	current_enjoyment = MAX_VISIBLE_ENJOYMENT
	_request_counter = request_cooldown_on_arrival
	set_process(true)


func leave() -> void:
	partner_sprite.hide()
	enjoyment_bar.hide()
	leave_bar.hide()
	thought_bubble.hide()
	set_process(false)


func restore_enjoyment() -> void:
	current_enjoyment = MAX_ENJOYMENT


func get_request() -> void:
	pass


func _update_enjoyment(delta: float) -> void:
	if not is_actor_present:
		current_enjoyment -= delta * enjoyment_decrease_rate
		if current_enjoyment < 0.0:
			current_enjoyment = 0.0
			if not is_wanting_to_leave:
				_start_leave_countdown()
			else:
				_update_leave_countdown(delta)
	else:
		current_enjoyment += delta * enjoyment_increase_rate
		if current_enjoyment > MAX_VISIBLE_ENJOYMENT:
			restore_enjoyment()
		if is_wanting_to_leave:
			_stop_leave_countdown()


func _start_leave_countdown() -> void:
	is_wanting_to_leave = true
	_leave_sec_counter = 1.0
	leave_countdown = LEAVE_WAIT_COUNT
	Globals.leave_counted_down.emit()
	leave_bar.value = 0.0
	leave_bar.show()


func _update_leave_countdown(delta: float) -> void:
	_leave_sec_counter -= delta
	if _leave_sec_counter <= 0.0:
		_leave_sec_counter = 1.0
		leave_countdown -= 1.0
		Globals.leave_counted_down.emit()
	leave_bar.value = LEAVE_WAIT_COUNT - leave_countdown
	if leave_countdown <= 0.0:
		leave()


func _stop_leave_countdown() -> void:
	is_wanting_to_leave = false
	leave_bar.hide()
