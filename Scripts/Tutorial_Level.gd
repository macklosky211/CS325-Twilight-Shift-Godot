extends Node3D
class_name Level

@onready var dusk: Node3D = $Dusk
@onready var dawn: Node3D = $Dawn
@onready var door_animation_player: AnimationPlayer = $Puzzle_Door/DoorAnimationPlayer
@onready var button_animation_player: AnimationPlayer = $Cube_001/ButtonAnimationPlayer

enum {DUSK, DAWN}

var current_dimension := DUSK

func _ready() -> void:
	_shift_dimension() # This puts us into DAWN at the start of the level...

func _shift_dimension() -> void:
	if current_dimension == DUSK: _toggle(dusk, false); _toggle(dawn, true); current_dimension = DAWN
	elif current_dimension == DAWN: _toggle(dawn, false); _toggle(dusk, true); current_dimension = DUSK

func _toggle(object : Node3D, visibility : bool) -> void:
	object.visible = visibility


func _on_tutorial_door_button_pressed() -> void:
	button_animation_player.play("Cube_001Action")
	await button_animation_player.animation_finished
	door_animation_player.play("Puzzle_DoorAction")


func _on_portal_collider_entered(body: Node3D) -> void:
	if body is not Player: return
	
	print("Completed the level!")
	body.end_level_animation_player.play("CRT_Poweroff")
	await body.end_level_animation_player.animation_finished
	body._lock_mouse(false) # Unlock the players mouse...
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
