extends Site

@onready var speech_bubble: TextureRect = %SpeechBubble
@onready var thought_bubble: TextureRect = %ThoughtBubble
@onready var disposed_sound: AudioStreamPlayer = $DisposedSound
@onready var joy_restored_sound: AudioStreamPlayer = $JoyRestoredSound

func _ready() -> void:
	recommend_visit(false)


func recommend_visit(is_recommended: bool) -> void:
	speech_bubble.show()
	thought_bubble.hide()
	super(is_recommended)


func recommend_gift(is_recommended: bool) -> void:
	speech_bubble.hide()
	thought_bubble.show()
	super.recommend_visit(is_recommended)


func on_actor_arriving(p_actor: Actor) -> void:
	super(p_actor)
	# actor is holding something
	if actor.currently_holding:
		var holdable_id = actor.currently_holding.id
		if Globals.ITEMS.has(holdable_id):
			ScoreTracker.correct_preference_given.emit(false)
			joy_restored_sound.play()
			actor.currently_holding = null
		elif Globals.FOOD_REQUESTS.has(holdable_id):
			actor.currently_holding = null
			disposed_sound.play()
	
