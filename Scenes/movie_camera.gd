extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer := get_tree().create_timer(2.0)
	await timer.timeout
	make_current()
	$AnimationPlayer.play("Camera_Animation")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Jump"):
		$AnimationPlayer.play("Camera_Animation")
