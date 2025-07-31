extends Level

@onready var animation_player_1: AnimationPlayer = $AnimationPlayer1
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Lava/StaticBody3D/AudioStreamPlayer3D

func _init() -> void:
	path = "res://Scenes/level_2.tscn"

func _ready() -> void:
	dawn = $"Dawn Platforms"
	dusk = $"Dusk Platforms"
	_shift_dimension() # This puts us into DAWN at the start of the level...
	queue_animation_1()
	queue_animation_2()

func queue_animation_1() -> void:
	animation_player_1.play("FloatingPlatform1")

func queue_animation_2() -> void:
	animation_player_2.play("FloatingPlatform2")

func _on_portal_entered(body: Node3D) -> void:
	if body is not Player: return
	
	body.end_level_animation_player.play("CRT_Poweroff")
	await body.end_level_animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")



func _on_lava_entered(body: Node3D) -> void:
	if body is not Player: return
	audio_stream_player_3d.play()
	body.reset()
