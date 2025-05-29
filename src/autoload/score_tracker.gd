extends Node

signal correct_food_given
signal correct_preference_given
signal activity_successful
signal score_added(base_point: float, multiplier: float)
signal one_second_ticked

@export var game_time_pts: float = 1.0
@export var food_request_pts: float = 5.0
@export var game_request_pts: float = 8.0
@export var correct_preference_pts: float = 5.0
@export var pts_multiplier_per_partner: float = 0.5

var game_time: float
var score: float

var _level
var _sec_counter: float

func _ready() -> void:
	set_process(false)
	correct_food_given.connect(_on_correct_food_given)
	correct_preference_given.connect(_on_correct_preference_given)
	activity_successful.connect(_on_activity_successful)


func _process(delta: float) -> void:
	game_time += delta
	_sec_counter += delta
	if _sec_counter >= 1.0:
		_sec_counter -= 1.0
		score += game_time_pts
		one_second_ticked.emit()


func start(level) -> void:
	game_time = 0.0
	score = 0
	_level = level
	set_process(true)


func finish() -> void:
	set_process(false)


func add_score(base_point: float, multiplier: float) -> void:
	score += base_point * multiplier
	score_added.emit(base_point, multiplier)


func _on_correct_food_given() -> void:
	add_score(food_request_pts, _get_partners_multiplier())


func _on_correct_preference_given() -> void:
	add_score(correct_preference_pts, _get_partners_multiplier())


func _on_activity_successful() -> void:
	add_score(game_request_pts, _get_partners_multiplier())


func _get_partners_multiplier() -> float:
	if not _level:
		return 0.0
	return _level.num_of_spawned_partners * pts_multiplier_per_partner
