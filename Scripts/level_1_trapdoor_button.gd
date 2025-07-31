extends Interactable

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func interact() -> void:
	animation_player.play("TrapDoorButton")
	audio_stream_player_3d.play()
	await animation_player.animation_finished
	animation_player.play("TrapDoor")
