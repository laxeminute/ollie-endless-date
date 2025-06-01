extends Node2D

const PATH_TO_GAME_OVER = "uid://dt2tlhl582r2j"

@export var player_starting_point: int
@export var date_location_spawn_order: Array[Site]

var score: int
var bonus_item_timer: float
var next_partner_timer: float
var num_of_spawned_partners: int
var _partner_spawn_order: Array

@onready var map: Map = $Map
@onready var player: Player = $Player


func _ready() -> void:
	player.initialize(map, player_starting_point)
	player.max_angst_reached.connect(_on_max_angst_reached)
	_partner_spawn_order = Globals.PARTNERS.duplicate()
	_partner_spawn_order.shuffle()
	num_of_spawned_partners = 0
	_on_next_partner_timeout()
	_on_next_partner_timeout()

	ScoreTracker.start(self)
	AudioManager.switch_to_gameplay_music()


func _on_max_angst_reached() -> void:
	SceneTransition.fade_to_scene(PATH_TO_GAME_OVER)
	ScoreTracker.finish()
	AudioManager.stop_music()
	ActivityOverlay.hide()


#func _get_next_bonus_item() -> String:
#if _bonus_item_queue.is_empty():
#_bonus_item_queue = Globals.ITEMS.duplicate()
#_bonus_item_queue.shuffle()
#return _bonus_item_queue.pop_back()


func _on_next_partner_timeout() -> void:
	if num_of_spawned_partners >= _partner_spawn_order.size():
		return
	var next_partner = _partner_spawn_order[num_of_spawned_partners]
	date_location_spawn_order[num_of_spawned_partners].spawn_partner(next_partner)
	num_of_spawned_partners += 1
