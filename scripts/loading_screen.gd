extends Control

@onready var fill_clip: Control = $CenterBox/BarContainer/FillClip
@onready var percent_label: Label = $CenterBox/PercentLabel
@onready var fade_overlay: ColorRect = $FadeOverlay

const MAX_FILL_WIDTH: float = 760.0

func _ready() -> void:
	fill_clip.size.x = 0.0
	percent_label.text = "0%"
	fade_overlay.color.a = 1.0
	
	# Fade in da tela de loading
	var tween_in = create_tween()
	tween_in.tween_property(fade_overlay, "color:a", 0.0, 0.4)
	tween_in.tween_callback(_start_loading)

func _start_loading() -> void:
	var load_tween = create_tween()
	load_tween.tween_method(_update_progress, 0.0, 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	load_tween.tween_interval(0.2)
	load_tween.tween_callback(_on_load_finished)

func _update_progress(value: float) -> void:
	fill_clip.size.x = MAX_FILL_WIDTH * value
	percent_label.text = "%d%%" % int(value * 100.0)

func _on_load_finished() -> void:
	var tween_out = create_tween()
	tween_out.tween_property(fade_overlay, "color:a", 1.0, 0.4)
	tween_out.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/tutorial_scene.tscn")
	)
