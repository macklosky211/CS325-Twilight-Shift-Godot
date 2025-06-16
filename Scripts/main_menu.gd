extends Control

@onready var start_button = $UI/ButtonContainer/StartButton
@onready var quit_button = $UI/ButtonContainer/QuitButton
@onready var title_label = $UI/TitleLabel
@onready var shader_material = $Background.material
@onready var shift_timer = $ShiftTimer
@onready var fade_rect = $FadeReact

var is_twilight = true

func _ready():
	print("MainMenu scene loaded!")
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	fade_rect.modulate = Color(1, 1, 1, 0)
	fade_rect.visible = false
	start_button.mouse_entered.connect(_on_start_button_mouse_entered)
	start_button.mouse_exited.connect(_on_start_button_mouse_exited)
	quit_button.mouse_entered.connect(_on_quit_button_mouse_entered)
	quit_button.mouse_exited.connect(_on_quit_button_mouse_exited)
	shift_timer.timeout.connect(_on_shift_timer_timeout)
	shift_timer.start()
	start_title_animation()

func _on_start_button_pressed():
	fade_out_then_change_scene("res://Scenes/tutorial.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(start_button, "self_modulate", Color(1.1, 1.1, 1.1), 0.1)
	tween.parallel().tween_property(start_button, "scale", Vector2(1.1, 1.1), 0.1)

func _on_start_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(start_button, "self_modulate", Color(1, 1, 1), 0.1)
	tween.parallel().tween_property(start_button, "scale", Vector2(1, 1), 0.1)

func _on_quit_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(quit_button, "self_modulate", Color(1.1, 1.1, 1.1), 0.1)
	tween.parallel().tween_property(quit_button, "scale", Vector2(1.1, 1.1), 0.1)

func _on_quit_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(quit_button, "self_modulate", Color(1, 1, 1), 0.1)
	tween.parallel().tween_property(quit_button, "scale", Vector2(1, 1), 0.1)

func _on_shift_timer_timeout():
	is_twilight = !is_twilight
	var tween = create_tween()
	tween.tween_method(_update_shader_shift, 
		shader_material.get_shader_parameter("shift_amount"), 
		1.0 if !is_twilight else 0.0, 
		2.0)

func _update_shader_shift(value: float):
	shader_material.set_shader_parameter("shift_amount", value)

func start_title_animation():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(title_label, "modulate:a", 0.3, 2.0)
	tween.tween_property(title_label, "modulate:a", 1.0, 2.0)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

func fade_out_then_change_scene(scene_path):
	var tween = create_tween()
	fade_rect.visible = true
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file(scene_path)
