extends Control

@onready var sample_sfx: AudioStreamPlayer = $SampleSFX
@onready var music_slider: Slider = %MusicSlider
@onready var sfx_slider: Slider = %SFXSlider


func _ready() -> void:
	music_slider.min_value = AudioManager.MIN_VOLUME_INDEX
	music_slider.max_value = AudioManager.MAX_VOLUME_INDEX
	music_slider.value = AudioManager.current_music_volume_index
	music_slider.value_changed.connect(_on_music_slider_value_changed)

	sfx_slider.min_value = AudioManager.MIN_VOLUME_INDEX
	sfx_slider.max_value = AudioManager.MAX_VOLUME_INDEX
	sfx_slider.value = AudioManager.current_sfx_volume_index
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.change_music_volume(int(value))
	sample_sfx.play()


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.change_sfx_volume(int(value))
	sample_sfx.play()
