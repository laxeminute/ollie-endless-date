extends Control

const PATH_TO_NEXT: String = "uid://bbtns8kd1br41"


func _on_start_button_pressed() -> void:
	SceneTransition.fade_to_scene(PATH_TO_NEXT)
