extends Node

@onready var tooltips_label: RichTextLabel = $Player/Camera3D/HUD/Tooltips_Label
@onready var tool_tip_timer: Timer = $ToolTip_Timer

func _ready() -> void:
	tool_tip_timer.timeout.connect(func() -> void: tooltips_label.visible = false)

func _set_text(text : String, time : float) -> void:
	tooltips_label.text = text
	tooltips_label.visible = true
	tool_tip_timer.start(time)


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
