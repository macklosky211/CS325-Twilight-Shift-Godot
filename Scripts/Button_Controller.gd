extends Interactable

signal button_pressed

@export var single_use : bool = false

func interact() -> void:
	button_pressed.emit()
	if single_use: self.set_script(null)
