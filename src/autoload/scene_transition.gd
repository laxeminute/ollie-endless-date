extends CanvasLayer

var root_window: Window

@export var default_fade_duration: float = 0.8
@export var tween_ease := Tween.EASE_OUT
@export var tween_transition := Tween.TRANS_QUAD

@onready var fade_rect: ColorRect = $FadeRect


func _ready() -> void:
	root_window = get_tree().root
	root_window.remove_child.call_deferred(self)


func fade_to_scene(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_error("Path not found: %s" % path)
		return
	ResourceLoader.load_threaded_request(path)

	root_window.add_child(self)
	get_tree().paused = true
	await _fade_to_black()

	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(path))

	await _fade_from_black()
	get_tree().paused = false
	root_window.remove_child(self)


func _fade_to_black(duration: float = default_fade_duration) -> void:
	fade_rect.modulate = Color.TRANSPARENT
	var tween := create_tween()
	tween.set_ease(tween_ease)
	tween.set_trans(tween_transition)
	tween.tween_property(fade_rect, "modulate", Color.WHITE, duration)
	await tween.finished


func _fade_from_black(duration: float = default_fade_duration) -> void:
	fade_rect.modulate = Color.WHITE
	var tween := create_tween()
	tween.set_ease(tween_ease)
	tween.set_trans(tween_transition)
	tween.tween_property(fade_rect, "modulate", Color.TRANSPARENT, duration)
	await tween.finished
