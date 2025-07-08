extends Level

@onready var tooltips_label: RichTextLabel = $Player/Camera3D/HUD/Tooltips_Label
@onready var tool_tip_timer: Timer = $ToolTip_Timer

@onready var door_animation_player: AnimationPlayer = $Tutorial/Puzzle_Door/DoorAnimationPlayer
@onready var button_animation_player: AnimationPlayer = $Tutorial/Cube_001/ButtonAnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _init() -> void:
	path = "res://Scenes/tutorial.tscn"

func _ready() -> void:
	tool_tip_timer.timeout.connect(func() -> void: tooltips_label.visible = false)
	dawn = $Tutorial/Dawn
	dusk = $Tutorial/Dusk
	_shift_dimension() # This puts us into DAWN at the start of the level...

func _set_text(text : String, time : float) -> void:
	tooltips_label.text = text
	tooltips_label.visible = true
	tool_tip_timer.start(time)

func _on_tutorial_door_button_pressed() -> void:
	button_animation_player.play("Cube_001Action")
	audio_stream_player_3d.play()
	await button_animation_player.animation_finished
	door_animation_player.play("Puzzle_DoorAction")

func _on_portal_collider_entered(body: Node3D) -> void:
	if body is not Player: return
	
	print("Completed the level!")
	body.end_level_animation_player.play("CRT_Poweroff")
	await body.end_level_animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

var tutorial_0 : bool = true
func _on_tutorial_0_entered(body: Node3D) -> void:
	if body is not Player: return
	if not tutorial_0: return
	tutorial_0 = false
	_set_text("
	Hey There! Welcome to twilight shift.
	
	You can move around using the WASD keys.
	You use your mouse to turn your camera.
	", 10)
	await tool_tip_timer.timeout
	_set_text("
	Nice! you can use \"F\"(Default) to interact with the enviornment
	Try using the button on the wall.
	", 10)

var tutorial_1 : bool = true
func _on_tutorial_1_entered(body: Node3D) -> void:
	if body is not Player: return
	if not tutorial_1: return
	tutorial_1 = false
	_set_text("
	Well Done!
	
	Now you can try using \"Shift\"(Default) to run!
	", 5)
	await tool_tip_timer.timeout
	_set_text("
	Now for the main event!
	
	Try using \"E\"(Default) to shift your reality!
	
	By doing this the enviornment may change, each of the dimensions has unique twists and features,
	but for now try scaling this tower!
	", 15)
	
var tutorial_2 : bool = true
func _on_tutorial_2_entered(body: Node3D) -> void:
	if body is not Player: return
	if not tutorial_2: return
	tutorial_2 = false
	_set_text("
	Some objects appear in any dimension, but if you meet certain conditions they may act differently.
	
	Shift to the \"Twilight Dawn\" Dimension and try going through this cage!
	", 10)
