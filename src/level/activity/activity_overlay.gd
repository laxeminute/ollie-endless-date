class_name ActivityOverlay
extends Control

signal completed
signal cancelled

@export var activity_scene: PackedScene

@onready var activity_container: Container = $ActivityContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	pass


func close() -> void:
	pass


func _on_cancel_button_pressed() -> void:
	cancelled.emit()
