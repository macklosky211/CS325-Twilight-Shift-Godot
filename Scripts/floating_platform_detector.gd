class_name MovingPlatform extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.is_on_moving_platform = self

var velocity : Vector3 = Vector3.ZERO
var last_pos : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	velocity = (global_position - last_pos) / delta
	last_pos = global_position

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.is_on_moving_platform = null
