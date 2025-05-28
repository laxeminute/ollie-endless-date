extends Control

const PATH_TO_TITLE = "uid://bmt3f0gx76jkh"

# TODO: replace with actual score
var score := 3000

@onready var base_text = %Description.text


func _ready() -> void:
	%Description.text = base_text % score


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(PATH_TO_TITLE)
