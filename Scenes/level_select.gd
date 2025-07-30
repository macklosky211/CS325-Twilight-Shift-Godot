extends Control

@onready var tutorial_btn = $VBoxContainer/GridContainer/TutorialButton
@onready var level1_btn = $VBoxContainer/GridContainer/Level1Button
@onready var level2_btn = $VBoxContainer/GridContainer/Level2Button
@onready var level3_btn = $VBoxContainer/GridContainer/Level3Button
@onready var back_btn = $VBoxContainer/GridContainer/BackButton

func _ready():
	# Connect button signals
	if tutorial_btn:
		tutorial_btn.pressed.connect(_on_tutorial_pressed)
	if level1_btn:
		level1_btn.pressed.connect(_on_level1_pressed)
	if level2_btn:
		level2_btn.pressed.connect(_on_level2_pressed)
	if level3_btn:
		level3_btn.pressed.connect(_on_level3_pressed)
	if back_btn:
		back_btn.pressed.connect(_on_back_pressed)

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_level1_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_level2_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")

func _on_level3_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
