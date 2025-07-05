extends Node
class_name Level

var path : String = "THIS HAS TO BE REPLACED!!!"

enum {DUSK, DAWN}
var current_dimension := DUSK

var dusk: Node3D # Collection of dusk nodes
var dawn: Node3D # Collection of dawn nodes

func _shift_dimension() -> void:
	if current_dimension == DUSK: _toggle(dusk, false); _toggle(dawn, true); current_dimension = DAWN
	elif current_dimension == DAWN: _toggle(dawn, false); _toggle(dusk, true); current_dimension = DUSK

func _toggle(object : Node3D, visibility : bool) -> void:
	object.visible = visibility
