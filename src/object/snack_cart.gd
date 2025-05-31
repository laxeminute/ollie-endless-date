extends Site

@export var prepare_duration: float = 30.0
@export var decay_duration: float = 10.0
@export var item_id: String = "I1"
var is_item_ready: bool
var _counter: float
@onready var speech_bubble: TextureProgressBar = %SpeechBubble
@onready var item_icon: TextureRect = %ItemIcon
@onready var check: TextureRect = %Check
@onready var pickup_sound: AudioStreamPlayer = $PickupSound

func _ready() -> void:
	_update_speech_bubble()


func _process(delta: float) -> void:
	if is_item_ready:
		_decay_item(delta)
	else:
		_prepare_item(delta)


func on_actor_arriving(p_actor: Actor) -> void:
	super(p_actor)
	if actor.currently_holding:
		return
	
	if is_item_ready:
		is_item_ready = false
		actor.currently_holding = {"id": item_id}
		pickup_sound.play()
		_update_speech_bubble()


func _prepare_item(delta: float) -> void:
	_counter += delta
	speech_bubble.value = _counter * speech_bubble.max_value / prepare_duration
	if _counter >= prepare_duration:
		_counter = 0.0
		speech_bubble.value = 0.0
		# actor is currently present
		if actor:
			actor.currently_holding = {"id": item_id}
			pickup_sound.play()
			is_item_ready = false
		else:
			is_item_ready = true
		_update_speech_bubble()


func _decay_item(delta: float) -> void:
	_counter += delta
	if _counter >= decay_duration:
		_counter = 0.0
		is_item_ready = false
		_update_speech_bubble()


func _update_speech_bubble() -> void:
	recommend_visit(is_item_ready)
	check.visible = is_item_ready
