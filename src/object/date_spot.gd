extends Site

const PartnerScene = preload("res://src/object/partner.tscn")

@export var default_bar_color := Color("99e550")
@export var bad_bar_color := Color("e65050")
@export var good_bar_color := Color("50c3e6")
@export var bar_tween_rate: float = 20.0

var partner: Partner
var enjoyment_style: StyleBoxFlat
var bar_tween: Tween

@onready var partner_anchor: Marker2D = $PartnerAnchor
@onready var enjoyment_bar: ProgressBar = $EnjoymentBar
@onready var leave_bar: TextureProgressBar = $LeaveBar
@onready var thought_bubble: TextureRect = %ThoughtBubble
@onready var request_icon: TextureRect = %RequestIcon
@onready var chat_sound: AudioStreamPlayer = $ChatSound

func _ready() -> void:
	_on_partner_left()
	enjoyment_style = enjoyment_bar.get_theme_stylebox("fill", "ProgressBar") as StyleBoxFlat
	enjoyment_bar.max_value = Partner.MAX_VISIBLE_ENJOYMENT
	leave_bar.max_value = Partner.LEAVE_WAIT_COUNT
	recommend_visit(true)


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
		else:
			partner.receive_item(holdable_id)
		actor.currently_holding = null
	# actor is visiting empty handed
	else:
		chat_sound.play()


func on_actor_leaving() -> void:
	if partner:
		var heading_to_game_booth := false
		var heading_to = actor._map.get_site_at_point(actor.current_path[0])
		if heading_to and heading_to.is_in_group("game_booth"):
			heading_to_game_booth = true
	
		if heading_to_game_booth and partner.is_requesting_minigame:
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
		partner.activity_successful()
	else:
		partner.finish_request()
		partner.activity_canceled()


func _update_enjoyment_bar(new_value: float) -> void:
	if not partner:
		return
	if bar_tween:
		if bar_tween.is_running():
			return
	var diff: float = min(new_value, enjoyment_bar.max_value) - enjoyment_bar.value
	if abs(diff) < 2.0:
		# don't bother animating small changes
		enjoyment_bar.value = new_value
		return

	enjoyment_style.bg_color = (good_bar_color if diff > 0 else bad_bar_color)
	bar_tween = create_tween()
	bar_tween.set_trans(Tween.TRANS_QUAD)
	bar_tween.set_ease(Tween.EASE_OUT)
	bar_tween.set_parallel()
	bar_tween.tween_property(
		enjoyment_style, "bg_color", default_bar_color, abs(diff) / bar_tween_rate
	)
	bar_tween.tween_property(enjoyment_bar, "value", new_value, abs(diff) / bar_tween_rate)


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
