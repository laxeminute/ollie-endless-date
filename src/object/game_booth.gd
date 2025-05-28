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
		# TODO: open minigame
		#open_minigame()
		
		# v REMOVE THIS IF OPEN MINIGAME IMPLEMENTED v
		# randomly simulate win or canceled
		if randf() > 0.2:
			on_minigame_won()
			print("minigame won")
		else:
			on_minigame_exited()
			print("minigame exited")
		# ^ REMOVE THIS ^


func on_actor_leaving() -> void:
	_partner = null
	super()


func open_minigame() -> void:
	pass


func on_minigame_won() -> void:
	actor.move_to(_return_location)
	_partner.finish_request()


func on_minigame_exited() -> void:
	actor.move_to(_return_location)
