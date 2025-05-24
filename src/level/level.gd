extends Node2D

@export var player_starting_point: int = 12

@onready var map: Map = $Map
@onready var player: Player = $Player

func _ready() -> void:
	player.initialize(map, player_starting_point)
