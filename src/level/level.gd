extends Node2D

@export var player_starting_point: int = 12

@onready var date_spots: Array
@onready var food_stalls: Array = get_tree().get_nodes_in_group("food_stalls")
@onready var game_booth: Array = get_tree().get_nodes_in_group("game_booth")

@onready var map: Map = $Map
@onready var player: Player = $Player

func _ready() -> void:
	player.initialize(map, player_starting_point)
	player.max_angst_reached.connect(_on_max_angst_reached)
	date_spots = get_tree().get_nodes_in_group("date_spot")
	date_spots[0].arrive()


func _on_max_angst_reached() -> void:
	print("GAME OVER")
