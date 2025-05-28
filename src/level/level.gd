extends Node2D

@export var player_starting_point: int
@export var date_location_spawn_order: Array[Site]

var score: int
var date_spots: Array
var bonus_item_timer: float
var next_partner_timer: float

var _current_spawn_index: int
var _partner_spawn_order: Array
var _bonus_item_queue: Array

@onready var map: Map = $Map
@onready var player: Player = $Player
@onready var snack_carts = get_tree().get_nodes_in_group("snack_cart")


func _ready() -> void:
	player.initialize(map, player_starting_point)
	player.max_angst_reached.connect(_on_max_angst_reached)
	_partner_spawn_order = Globals.PARTNERS.duplicate()
	_partner_spawn_order.shuffle()
	_current_spawn_index = 0
	_on_next_partner_timeout()
	_on_next_partner_timeout()


func _on_max_angst_reached() -> void:
	# TODO: game over screen
	print("GAME OVER")


func _on_bonus_item_timeout() -> void:
	var item = _get_next_bonus_item()
	var cart = snack_carts.pick_random()
	cart.spawn_item(item)


func _get_next_bonus_item() -> String:
	if _bonus_item_queue.is_empty():
		_bonus_item_queue = Globals.ITEMS.duplicate()
		_bonus_item_queue.shuffle()
	return _bonus_item_queue.pop_back()


func _on_next_partner_timeout() -> void:
	if _current_spawn_index >= _partner_spawn_order.size():
		print("reached max spawn")
		return
	var next_partner = _partner_spawn_order[_current_spawn_index]
	date_location_spawn_order[_current_spawn_index].spawn_partner(next_partner)
	_current_spawn_index += 1


func _on_button_pressed() -> void:
	%ActivityOverlay.open(randi_range(0, 3))
