class_name Submenu
extends PanelContainer

signal closed

@export var content_list: Array[PackedScene]
@export var menu_titles: Array[String] = ["How to Play", "Settings", "Credits"]

var current_contents: Control

@onready var title: Label = %Title
@onready var content: Control = %Content
@onready var back_button: Button = %BackButton


func open(id: int) -> void:
	if current_contents:
		push_warning("Trying to open when contents are active")
		current_contents.queue_free()
	current_contents = content_list[id].instantiate()
	content.add_child(current_contents)
	title.text = menu_titles[id]
	back_button.show()
	back_button.grab_focus.call_deferred()
	# TODO: animations
	show()


func close() -> void:
	back_button.hide()
	back_button.release_focus()
	# TODO: animations
	hide()
	current_contents.queue_free()
	closed.emit()


func _on_back_button_pressed() -> void:
	close()
