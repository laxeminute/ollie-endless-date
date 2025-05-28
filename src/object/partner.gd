class_name Partner
extends Sprite2D

signal request_updated
signal enjoyment_updated
signal leave_countdown_updated
signal leave_countdown_ended

const MAX_ENJOYMENT = 50.0
const MAX_VISIBLE_ENJOYMENT = 40.0
const LEAVE_WAIT_COUNT = 5.0

@export var enjoyment_decrease_rate: float = 1.0
@export var enjoyment_increase_rate: float = 4.0
@export var request_cooldown_on_arrival: float = 2.0
@export var request_cooldown: float = 10.0
@export var enjoyment_decrease_on_wrong_food: float = 20.0
@export var enjoyment_decrease_on_canceled_activity: float = 20.0

var id: String
var date_spot: Site

var current_enjoyment: float
var is_wanting_to_leave: bool
var leave_countdown: float
var current_request: String
var is_following_actor: bool

var _leave_sec_counter: float
var _request_counter: float
var _request_queue: Array[String]


func initialize(p_id: String, p_date_spot: Site) -> void:
	id = p_id
	date_spot = p_date_spot
	texture = Globals.Icons[id]

	current_enjoyment = MAX_VISIBLE_ENJOYMENT
	_request_counter = request_cooldown_on_arrival


func _process(delta: float) -> void:
	if is_following_actor:
		return
	_update_enjoyment(delta)
	_check_request(delta)


func restore_enjoyment() -> void:
	current_enjoyment = MAX_ENJOYMENT
	enjoyment_updated.emit()


func finish_request() -> void:
	_request_counter = request_cooldown
	current_request = ""
	request_updated.emit()


func receive_wrong_food() -> void:
	current_enjoyment -= enjoyment_decrease_on_wrong_food
	Globals.wrong_food_given.emit()
	if current_enjoyment < 0.0:
		current_enjoyment = 0.0
	enjoyment_updated.emit()


func follow_actor() -> void:
	is_following_actor = true


func returning_with_actor() -> void:
	is_following_actor = false


func ruined_activity() -> void:
	current_enjoyment -= enjoyment_decrease_on_canceled_activity
	Globals.activity_canceled.emit()
	if current_enjoyment < 0.0:
		current_enjoyment = 0.0
	enjoyment_updated.emit()


func receive_bonus_item(item_id: String) -> void:
	var preference = Globals.PREFERENCES[id]
	if preference == item_id:
		restore_enjoyment()
	else:
		receive_wrong_food()


func _update_enjoyment(delta: float) -> void:
	if not date_spot.actor:
		current_enjoyment -= delta * enjoyment_decrease_rate
		enjoyment_updated.emit()
		if current_enjoyment < 0.0:
			current_enjoyment = 0.0
			if not is_wanting_to_leave:
				_start_leave_countdown()
			else:
				_update_leave_countdown(delta)
	else:
		current_enjoyment += delta * enjoyment_increase_rate
		enjoyment_updated.emit()
		if current_enjoyment > MAX_VISIBLE_ENJOYMENT:
			restore_enjoyment()
		if is_wanting_to_leave:
			_stop_leave_countdown()


func _start_leave_countdown() -> void:
	is_wanting_to_leave = true
	_leave_sec_counter = 1.0
	leave_countdown = LEAVE_WAIT_COUNT
	Globals.leave_counted_down.emit()
	leave_countdown_updated.emit()


func _update_leave_countdown(delta: float) -> void:
	_leave_sec_counter -= delta
	if _leave_sec_counter <= 0.0:
		_leave_sec_counter = 1.0
		leave_countdown -= 1.0
		Globals.leave_counted_down.emit()
		leave_countdown_updated.emit()
	if leave_countdown <= 0.0:
		leave_countdown_ended.emit()


func _stop_leave_countdown() -> void:
	is_wanting_to_leave = false
	leave_countdown_updated.emit()


func _check_request(delta: float) -> void:
	if current_request.is_empty():
		_request_counter -= delta
		if _request_counter <= 0.0:
			current_request = _get_next_request()
			request_updated.emit()


func _get_next_request() -> String:
	if _request_queue.is_empty():
		# pick 1 random food request
		_request_queue.append(Globals.FOOD_REQUESTS[randi() % Globals.NUM_OF_FOOD])
		# pick 1 random game request
		_request_queue.append(Globals.GAME_REQUESTS[randi() % Globals.NUM_OF_GAME])
		# randomize the order
		_request_queue.shuffle()
	return _request_queue.pop_back()
