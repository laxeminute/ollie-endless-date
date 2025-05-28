class_name Player
extends Node2D

signal max_angst_reached

const MAX_ANGST = 100.0
const Portraits = [
	preload("res://assets/sprite/portrait_1.atlastex"),
	preload("res://assets/sprite/portrait_2.atlastex"),
	preload("res://assets/sprite/portrait_3.atlastex"),
	preload("res://assets/sprite/portrait_4.atlastex"),
	preload("res://assets/sprite/portrait_5.atlastex"),
]

@export_group("Difficulty")
@export var angst_increase_on_leave_count: float = 10.0
@export var angst_increase_on_wrong_food: float = 5.0
@export var angst_increase_on_activity_canceled: float = 5.0
@export_group("Visuals")
## Update rate of the bar, in angst points per second.
@export var angst_tween_rate: float = 20.0

var current_angst: float
var is_in_minigame: bool

@onready var actor: Actor = $Actor
@onready var avatar: TextureRect = %Avatar
@onready var angst_bar: TextureProgressBar = %AngstBar
@onready var item_icon: TextureRect = %ItemIcon
@onready var score: Label = %Score
@onready var time: Label = %Time
@onready var border_flash: BorderFlash = %BorderFlash


func _ready() -> void:
	Globals.leave_counted_down.connect(_on_leave_counted_down)
	Globals.wrong_food_given.connect(_on_wrong_food_given)
	Globals.minigame_mode_enabled.connect(_on_minigame_mode)
	Globals.activity_canceled.connect(_on_activity_canceled)
	angst_bar.max_value = MAX_ANGST
	actor.holdable_updated.connect(_on_holdable_updated)


func initialize(map: Map, starting_point: int) -> void:
	actor.initialize(map, starting_point)
	actor.show()
	current_angst = 0.0
	avatar.texture = Portraits[0]
	angst_bar.value = current_angst


func _unhandled_input(event: InputEvent) -> void:
	if is_in_minigame:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var site = _get_selected_site()
			if site:
				actor.move_to(site.location_id)


func add_angst(value: float) -> void:
	current_angst += value
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(angst_bar, "value", current_angst, value / angst_tween_rate)
	_update_avatar()
	if current_angst >= MAX_ANGST:
		max_angst_reached.emit()


func _on_leave_counted_down() -> void:
	border_flash.flash()
	add_angst(angst_increase_on_leave_count)


func _on_wrong_food_given() -> void:
	add_angst(angst_increase_on_wrong_food)


func _on_minigame_mode(enabled: bool) -> void:
	is_in_minigame = enabled


func _on_activity_canceled() -> void:
	add_angst(angst_increase_on_activity_canceled)


func _get_selected_site() -> Site:
	var mouse_pos = get_global_mouse_position()
	var space = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = mouse_pos
	params.collision_mask = Globals.SITE_COLLISION_LAYER
	params.collide_with_bodies = false
	params.collide_with_areas = true

	var areas = space.intersect_point(params, 4)
	var site: Site = null
	for i in areas.size():
		site = areas[i].collider as Site
		if site:
			break

	return site


func _update_avatar() -> void:
	if current_angst < MAX_ANGST * 0.2:
		avatar.texture = Portraits[0]
	elif current_angst < MAX_ANGST * 0.4:
		avatar.texture = Portraits[1]
	elif current_angst < MAX_ANGST * 0.6:
		avatar.texture = Portraits[2]
	elif current_angst < MAX_ANGST * 0.8:
		avatar.texture = Portraits[3]
	else:
		avatar.texture = Portraits[4]


func _on_holdable_updated() -> void:
	if actor.currently_holding:
		item_icon.texture = Globals.Icons[actor.currently_holding.id]
	else:
		item_icon.texture = null
