extends Control

const PATH_TO_TITLE = "uid://bmt3f0gx76jkh"

@onready var base_text = %Description.text


func _ready() -> void:
	%Description.text = base_text % ScoreTracker.score
	%BackButton.grab_focus.call_deferred()


func _on_back_button_pressed() -> void:
	SceneTransition.fade_to_scene(PATH_TO_TITLE, 0.2)
