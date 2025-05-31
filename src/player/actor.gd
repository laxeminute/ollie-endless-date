class_name Actor
extends Sprite2D

signal holdable_updated

@export var move_speed: float = 200.0

var current_path: Array[int]
var current_point: int
var is_moving: bool
var current_site: Site
var currently_holding:
	get:
		return currently_holding
	set(value):
		currently_holding = value
		holdable_updated.emit()
		_update_dispose_recommendation()

var _map: Map
var _currently_move_toward: Vector2

@onready var held_partner: Sprite2D = $HeldPartner
@onready var walk_sound: AudioStreamPlayer = $WalkSound

func initialize(map: Map, starting_point: int) -> void:
	_map = map
	current_path = []
	current_point = starting_point
	is_moving = false
	position = _map.get_point_position(starting_point)
	_currently_move_toward = position


func _process(delta: float) -> void:
	if not is_moving:
		return

	if position.distance_to(_currently_move_toward) > 1.0:
		position = position.move_toward(_currently_move_toward, move_speed * delta)
	else:
		# try getting new current_point
		var next_point = current_path.pop_back()
		if next_point != null:
			current_point = next_point
			_currently_move_toward = _map.get_point_position(current_point)
		else:
			# arrived at site
			is_moving = false
			on_arriving_at_site()


func move_to(end_point: int) -> void:
	current_path = _map.get_path_stack(current_point, end_point)
	is_moving = true
	walk_sound.play()
	on_leaving_site()


func on_arriving_at_site() -> void:
	var site = _map.get_site_at_point(current_point)
	site.on_actor_arriving(self)
	current_site = site
	_update_visit_recommendations()


func on_leaving_site() -> void:
	if not current_site:
		return
	current_site.on_actor_leaving()
	current_site = null


func _update_visit_recommendations() -> void:
	if current_site and current_site.is_in_group("date_spot"):
		if current_site.partner and current_site.partner.is_requesting_minigame:
			get_tree().call_group("food_stall", "recommend_visit", false)
			get_tree().call_group("game_booth", "recommend_visit", true)
			return
	
	get_tree().call_group("food_stall", "recommend_visit", not currently_holding)
	get_tree().call_group("game_booth", "recommend_visit", false)


func _update_dispose_recommendation() -> void:
	if not currently_holding:
		get_tree().call_group("disposer", "recommend_visit", false)
	else:
		if currently_holding.id[0] == "F":
			get_tree().call_group("disposer", "recommend_visit", true)
		elif currently_holding.id[0] == "I":
			get_tree().call_group("disposer", "recommend_gift", true)
		else:
			get_tree().call_group("disposer", "recommend_visit", false)
