extends Interactable

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func interact() -> void:
	animation_player.play("DoorsButton")
	await animation_player.animation_finished
	animation_player.play("Lower_Door")
	await animation_player.animation_finished
	animation_player.play("Upper_Door")
