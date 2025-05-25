class_name Player
extends Node2D

signal max_angst_reached

const MAX_ANGST = 100.0

@export var angst_increase_on_leave_count: float = 10.0

var current_angst: float

@onready var actor: Sprite2D = $Actor
@onready var avatar: TextureRect = %Avatar
@onready var angst_bar: TextureProgressBar = %AngstBar
@onready var item_icon: TextureRect = %ItemIcon
@onready var score: Label = %Score
@onready var time: Label = %Time

func _ready() -> void:
	Globals.leave_counted_down.connect(_on_leave_counted_down)
	angst_bar.max_value = MAX_ANGST


func initialize(map: Map, starting_point: int) -> void:
	actor.initialize(map, starting_point)
	actor.show()
	current_angst = 0.0
	angst_bar.value = current_angst


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var site = _get_selected_site()
			if site:
				actor.move_to(site.location_id)


func add_angst(value: float) -> void:
	current_angst += value
	angst_bar.value = current_angst
	if current_angst >= MAX_ANGST:
		max_angst_reached.emit()


func _on_leave_counted_down() -> void:
	add_angst(angst_increase_on_leave_count)


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
