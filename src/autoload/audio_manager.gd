extends Node

const LINEAR_BUS_VOLUME_VALUES = [ 0.0, 0.1, 0.4, 0.7, 1.0, 1.3, 1.6 ]
const MIN_VOLUME_INDEX = 0
const MAX_VOLUME_INDEX = 6
const DEFAULT_VOLUME_INDEX = 4

enum AudioBus { Master, SFX, Music }
var bus_volume_index: Array = [ DEFAULT_VOLUME_INDEX, DEFAULT_VOLUME_INDEX, DEFAULT_VOLUME_INDEX ]

var current_sfx_volume_index: int:
	get:
		return bus_volume_index[AudioBus.SFX]

var current_music_volume_index: int:
	get:
		return bus_volume_index[AudioBus.Music]

@onready var music_player: Node = $MusicPlayer

func _ready() -> void:
	reset_volume()


func change_sfx_volume(volume_index: int) -> void:
	_change_bus_volume(AudioBus.SFX, volume_index)


func change_music_volume(volume_index: int) -> void:
	_change_bus_volume(AudioBus.Music, volume_index)


func reset_volume() -> void:
	change_sfx_volume(DEFAULT_VOLUME_INDEX)
	change_music_volume(DEFAULT_VOLUME_INDEX)


func play_music() -> void:
	music_player.play_music()


func stop_music() -> void:
	music_player.stop_music()


func switch_to_intro_music() -> void:
	music_player.switch_to_intro_music()


func switch_to_gameplay_music() -> void:
	music_player.switch_to_gameplay_music()


func _change_bus_volume(bus_index: int, volume_index: int) -> void:
	if volume_index >= LINEAR_BUS_VOLUME_VALUES.size():
		return
	if volume_index <= 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		if AudioServer.is_bus_mute(bus_index):
			AudioServer.set_bus_mute(bus_index, false)
		var db = linear_to_db(LINEAR_BUS_VOLUME_VALUES[volume_index])
		AudioServer.set_bus_volume_db(bus_index, db)
	bus_volume_index[bus_index] = volume_index
