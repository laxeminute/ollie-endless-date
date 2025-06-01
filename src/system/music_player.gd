extends Node

# Normally I would use AudioStreamInteractive to transition and loop audio.
# Unfortunately it doesn't support 'Sample' playback on HTML builds
# and Godot 4 web games would get laggy without it.
# This is just a quick script to mimic what AudioStreamInteractive can normally do.

enum Tracks { INTRO, INTROLOOP, GAMEPLAY, GAMEPLAYLOOP }

var current_track: int
var loop_track: int

func play_music() -> void:
	get_child(current_track).play()


func stop_music() -> void:
	get_child(current_track).stop()
	current_track = 0


func switch_to_intro_music() -> void:
	loop_track = Tracks.INTROLOOP


func switch_to_gameplay_music() -> void:
	loop_track = Tracks.GAMEPLAYLOOP


func _on_track_finished() -> void:
	if current_track != loop_track:
		if current_track == Tracks.GAMEPLAYLOOP:
			current_track = 0
		else:
			current_track += 1
	
	get_child(current_track).play()
