extends Site

var current_item: String = ""
@onready var speech_bubble: TextureRect = $SpeechBubble
@onready var item_icon: TextureRect = $SpeechBubble/ItemIcon


func _ready() -> void:
	speech_bubble.hide()


func spawn_item(item_id: String) -> void:
	if not current_item.is_empty():
		return
	current_item = item_id
	item_icon.texture = Globals.Icons[item_id]
	speech_bubble.show()


func on_actor_arriving(p_actor: Actor) -> void:
	super(p_actor)
	if actor.currently_holding:
		return

	if not current_item.is_empty():
		speech_bubble.hide()
		actor.currently_holding = {"id": current_item}
		current_item = ""
