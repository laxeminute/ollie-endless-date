extends Site

const PartnerScene = preload("res://src/object/partner.tscn")

var partner: Partner

@onready var partner_anchor: Marker2D = $PartnerAnchor
@onready var enjoyment_bar: ProgressBar = $EnjoymentBar
@onready var leave_bar: TextureProgressBar = $LeaveBar
@onready var thought_bubble: TextureRect = $ThoughtBubble
@onready var request_icon: TextureRect = $ThoughtBubble/RequestIcon


func _ready() -> void:
	_on_partner_left()
	enjoyment_bar.max_value = Partner.MAX_VISIBLE_ENJOYMENT
	leave_bar.max_value = Partner.LEAVE_WAIT_COUNT


func spawn_partner(id: String) -> void:
	partner = PartnerScene.instantiate()
	partner_anchor.add_child(partner)
	partner.request_updated.connect(_update_thought_bubble)
	partner.enjoyment_updated.connect(_update_enjoyment_bar)
	partner.leave_countdown_updated.connect(_update_leave_bar)
	partner.leave_countdown_ended.connect(on_partners_leave_countdown_ended)
	partner.initialize(id, self)
	_on_partner_arrived()


func on_partners_leave_countdown_ended() -> void:
	partner.queue_free()
	partner = null
	_on_partner_left()


func on_actor_arriving(p_actor: Actor) -> void:
	super(p_actor)
	if not partner:
		return

	# actor is holding something
	if actor.currently_holding:
		var holdable_id = actor.currently_holding.id
		if holdable_id == partner.id:
			_on_returning_from_activity()
		# correct food
		elif holdable_id == partner.current_request:
			partner.finish_request()
			partner.restore_enjoyment()
		# bonus item
		elif Globals.ITEMS.has(holdable_id):
			partner.receive_bonus_item(holdable_id)
		# wrong food
		else:
			partner.receive_wrong_food()

		actor.currently_holding = null


func on_actor_leaving() -> void:
	if partner and not partner.current_request.is_empty():
		var heading_to_game_booth := false
		var heading_to = actor._map.get_site_at_point(actor.current_path[0])
		if heading_to and heading_to.is_in_group("game_booth"):
			heading_to_game_booth = true
		var requesting_minigame := partner.current_request[0] == "G"

		if heading_to_game_booth and requesting_minigame:
			actor.currently_holding = partner
			actor.held_partner.texture = partner.texture
			partner.follow_actor()
			_on_partner_left()

	super()


func _on_partner_arrived() -> void:
	partner_anchor.show()
	enjoyment_bar.show()
	_update_thought_bubble()


func _on_partner_left() -> void:
	partner_anchor.hide()
	enjoyment_bar.hide()
	leave_bar.hide()
	thought_bubble.hide()


func _on_returning_from_activity() -> void:
	partner.returning_with_actor()
	Globals.minigame_mode_enabled.emit(false)
	actor.held_partner.texture = null
	_on_partner_arrived()
	if partner.current_request.is_empty():
		partner.restore_enjoyment()
	else:
		partner.finish_request()
		partner.ruined_activity()


func _update_enjoyment_bar() -> void:
	if not partner:
		return
	enjoyment_bar.value = partner.current_enjoyment


func _update_thought_bubble() -> void:
	if not partner or partner.current_request.is_empty():
		thought_bubble.hide()
	else:
		request_icon.texture = Globals.Icons[partner.current_request]
		thought_bubble.show()


func _update_leave_bar() -> void:
	if not partner:
		return
	leave_bar.visible = partner.is_wanting_to_leave
	leave_bar.value = Partner.LEAVE_WAIT_COUNT - partner.leave_countdown
