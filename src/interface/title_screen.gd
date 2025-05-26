extends Control

@export var next_scene: PackedScene


func _on_start_button_pressed() -> void:
	# TODO: loading screen
	get_tree().change_scene_to_packed(next_scene)
