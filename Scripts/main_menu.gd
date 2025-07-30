extends Control

@onready var start_button = $UI/StartButton
@onready var settings_button = $UI/SettingsButton
@onready var quit_button = $UI/QuitButton
@onready var title_label = $UI/TitleLabel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_twilight = true

func _ready():
	print("MainMenu scene loaded!")
	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	start_title_animation()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_button_pressed():
	audio_stream_player_2d.play()
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

func _on_settings_button_pressed():
	audio_stream_player_2d.play()
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func start_title_animation():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(title_label, "modulate:a", 0.3, 2.0)
	tween.tween_property(title_label, "modulate:a", 1.0, 2.0)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
