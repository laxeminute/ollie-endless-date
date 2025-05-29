extends Control

const PATH_TO_NEXT: String = "uid://bbtns8kd1br41"

var buttons: Array[Button]
@onready var submenu: Submenu = $Submenu


func _ready() -> void:
	AudioManager.switch_to_intro_music()
	AudioManager.play_music()
	for b: Button in %Buttons.get_children():
		buttons.append(b)
	buttons[0].grab_focus.call_deferred()


func _on_start_button_pressed() -> void:
	SceneTransition.fade_to_scene(PATH_TO_NEXT)


func _on_tutorial_button_pressed() -> void:
	submenu.open(0)


func _on_settings_button_pressed() -> void:
	submenu.open(1)


func _on_credits_button_pressed() -> void:
	submenu.open(2)


func _on_submenu_closed() -> void:
	buttons[0].grab_focus()
