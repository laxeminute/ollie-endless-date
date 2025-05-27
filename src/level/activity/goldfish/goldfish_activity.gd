extends Node2D

signal completed

const HEIGHT = 192
const WIDTH = 192
const HALF_HEIGHT = HEIGHT / 2.0
const HALF_WIDTH = WIDTH / 2.0

const FishScene = preload("uid://dxje2lxp6qxfr")

@export var catcher_agility: float = 16.0
@export_range(1, 10) var num_fishes: int = 4

@onready var catcher: Catcher = $Catcher
@onready var fish_group: Node2D = $Fishes


func _ready() -> void:
	for _i in num_fishes:
		fish_group.add_child(FishScene.instantiate())


func _process(delta: float) -> void:
	if catcher.catching:
		return
	var target_position: Vector2 = get_local_mouse_position().clamp(
		Vector2(-HALF_WIDTH + catcher.radius, -HALF_HEIGHT + catcher.radius),
		Vector2(HALF_WIDTH - catcher.radius, HALF_HEIGHT - catcher.radius)
	)
	catcher.position = Globals.exp_decay(catcher.position, target_position, delta, catcher_agility)


func _on_click_detector_clicked() -> void:
	catcher.catch()


func _on_catcher_caught_fish() -> void:
	completed.emit()
