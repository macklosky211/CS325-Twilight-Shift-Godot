extends Node3D
class_name Level

@onready var dusk: Node3D = $Dusk
@onready var dawn: Node3D = $Dawn

enum {DUSK, DAWN}

var current_dimension := DUSK

func _ready() -> void:
	_shift_dimension() # This puts us into DAWN at the start of the level...

func _shift_dimension() -> void:
	if current_dimension == DUSK: _toggle(dusk, false); _toggle(dawn, true); current_dimension = DAWN
	elif current_dimension == DAWN: _toggle(dawn, false); _toggle(dusk, true); current_dimension = DUSK

func _toggle(object : Node3D, visibility : bool) -> void:
	object.visible = visibility
