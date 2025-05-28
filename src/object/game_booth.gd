extends Site

@export var game_id: String = "G1"
var _partner: Partner
var _return_location: int


func _ready() -> void:
	$SpeechBubble/RequestIcon.texture = Globals.Icons[game_id]


func on_actor_arriving(p_actor: Actor) -> void:
	super(p_actor)

	if not actor.currently_holding or not actor.currently_holding is Partner:
		return

	_partner = actor.currently_holding
	Globals.minigame_mode_enabled.emit(true)

	_return_location = _partner.date_spot.location_id
	if _partner.current_request != game_id:
		actor.move_to(_return_location)
	else:
		open_minigame()


func on_actor_leaving() -> void:
	_partner = null
	super()


func open_minigame() -> void:
	ActivityOverlay.open_string(game_id)
	ActivityOverlay.finished.connect(_on_minigame_finished)


func _on_minigame_finished(success: bool) -> void:
	ActivityOverlay.finished.disconnect(_on_minigame_finished)
	if success:
		_partner.finish_request()
	else:
		Globals.activity_canceled.emit()
	actor.move_to(_return_location)
