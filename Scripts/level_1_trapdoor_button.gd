extends Interactable

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func interact() -> void:
	animation_player.play("TrapDoorButton")
	await animation_player.animation_finished
	animation_player.play("TrapDoor")
