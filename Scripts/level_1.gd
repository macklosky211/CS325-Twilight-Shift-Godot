extends Level

func _init() -> void:
	path = "res://Scenes/level_1.tscn"

func _ready() -> void:
	dawn = $"Dawn Platforms "
	dusk = $"Dusk Platforms "
	_shift_dimension() # This puts us into DAWN at the start of the level...


func _on_portal_entered(body: Node3D) -> void:
	if body is not Player: return
	body.end_level_animation_player.play("CRT_Poweroff")
	await body.end_level_animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")


func _lava_entered(body: Node3D) -> void:
	if body is not Player: return
	body.reset()
	
