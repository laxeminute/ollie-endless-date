extends Site

@export var food_id: String = "F1"
@export var cook_duration: float = 4.0
var is_cooking: bool
var is_food_ready: bool
var _cook_progress: float
@onready var speech_bubble: TextureProgressBar = %SpeechBubble
@onready var check: TextureRect = %Check
@onready var food_start_sound: AudioStreamPlayer = $FoodStartSound
@onready var food_ready_sound: AudioStreamPlayer = $FoodReadySound
@onready var pickup_sound: AudioStreamPlayer = $PickupSound

func _ready() -> void:
	%RequestIcon.texture = Globals.Icons[food_id]
	recommend_visit(true)
	check.hide()


func on_actor_arriving(p_actor: Actor) -> void:
	super(p_actor)
	if actor.currently_holding:
		return

	if is_food_ready:
		is_food_ready = false
		check.hide()
		actor.currently_holding = {"id": food_id}
		pickup_sound.play()
	else:
		if not is_cooking:
			_cook_progress = 0.0
			is_cooking = true
			food_start_sound.play()


func _process(delta: float) -> void:
	if not is_cooking:
		return
	_update_cook_progress(delta)


func _update_cook_progress(delta: float) -> void:
	_cook_progress += delta
	speech_bubble.value = _cook_progress * speech_bubble.max_value / cook_duration
	if _cook_progress >= cook_duration:
		is_cooking = false
		speech_bubble.value = 0.0
		# actor is currently present
		if actor:
			actor.currently_holding = {"id": food_id}
			pickup_sound.play()
		else:
			is_food_ready = true
			check.show()
			food_ready_sound.play()
