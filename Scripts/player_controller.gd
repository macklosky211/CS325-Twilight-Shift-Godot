extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var level : Level = $".."
@onready var switch_timer: Timer = $Switch_Timer
@onready var end_level_animation_player: AnimationPlayer = $Camera3D/HUD/End_Level_Effect/End_Level_Animation_Player
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

const ACCEL : float = 1.0
const SPRINT_SPEED: float = 7.5
const WALK_SPEED : float = 5.0
const JUMP_VELOCITY : float = 3.0
const CAMERA_SENS : float = 0.001
const SWITCH_TIME : float = 1.0
const MAX_CHARGE_TIME: float = 2.0
const MIN_JUMP_FORCE: float = 3.0
const MAX_JUMP_FORCE: float = 10.0

var is_mouse_locked : bool = false
var can_toggle_dimension : bool = true
var is_on_moving_platform : MovingPlatform = null
var is_charging_jump: bool = false
var jump_charge_timer: float = 0.0

func _ready() -> void:
	randomize()
	_toggle_dimension()
	switch_timer.timeout.connect(func(): can_toggle_dimension = true)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() or is_on_moving_platform:
		if Input.is_action_pressed("Charge_Jump"):
			if not is_charging_jump:
				is_charging_jump = true
				jump_charge_timer = 0.0
			else:
				jump_charge_timer += delta
		elif is_charging_jump and Input.is_action_just_released("Charge_Jump"):
			is_charging_jump = false
			var charge_ratio = clampf(jump_charge_timer / MAX_CHARGE_TIME, 0.0, 1.0)
			var jump_force = lerp(MIN_JUMP_FORCE, MAX_JUMP_FORCE, charge_ratio)
			velocity.y = jump_force
			audio_stream_player_3d.play()

	if Input.is_action_just_pressed("Jump") and (is_on_floor() or is_on_moving_platform):
		velocity.y = JUMP_VELOCITY
		var pitch_variation = randf_range(0.9, 1.1)
		audio_stream_player_3d.pitch_scale = pitch_variation
		audio_stream_player_3d.play()
	
	if Input.is_action_just_pressed("Shift_Dimension") and can_toggle_dimension:
		can_toggle_dimension = false
		level._shift_dimension()
		_toggle_dimension()
	elif switch_timer.is_stopped():
		switch_timer.start(SWITCH_TIME)
	
	if Input.is_action_just_pressed("Interact"):
		_try_interacting()
	if Input.is_action_just_pressed("Escape"):
		_lock_mouse(not is_mouse_locked)
	if Input.is_action_just_pressed("Reset"):
		reset()
	
	var input_dir : Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	var speed : float = SPRINT_SPEED if Input.is_action_pressed("Sprint") else WALK_SPEED
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_moving_platform:
		speed += absf(is_on_moving_platform.velocity.length())
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, ACCEL)
		velocity.z = move_toward(velocity.z, direction.z * speed, ACCEL)
	elif is_on_moving_platform:
		velocity = velocity.move_toward(is_on_moving_platform.velocity, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		camera.rotation.x = clampf(camera.rotation.x - event.relative.y * CAMERA_SENS, -1.5, 1.75)
	elif event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			_lock_mouse(true)

func _lock_mouse(val : bool) -> void:
	is_mouse_locked = val
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_mouse_locked else Input.MOUSE_MODE_VISIBLE

enum {DUSK, DAWN}
var current_dimension := DUSK

func _toggle_collision_mask(val) -> void:
	if val == DUSK:
		collision_layer = 3
		collision_mask = 3
	elif val == DAWN:
		collision_layer = 5
		collision_mask = 5

func _toggle_dimension() -> void:
	if current_dimension == DUSK:
		current_dimension = DAWN
		_set_skybox(DAWN)
		_toggle_collision_mask(DAWN)
	elif current_dimension == DAWN:
		current_dimension = DUSK
		_set_skybox(DUSK)
		_toggle_collision_mask(DUSK)

const DAWN_SKYBOX = preload("res://Assets/Skyboxes/Dawn_Skybox.tres")
const DUSK_SKYBOX = preload("res://Assets/Skyboxes/Dusk_Skybox.tres")
@onready var world_environment: WorldEnvironment = $Camera3D/WorldEnvironment

func _set_skybox(val) -> void:
	world_environment.environment = DAWN_SKYBOX if val == DAWN else DUSK_SKYBOX

func _try_interacting() -> void:
	if raycast.is_colliding() and raycast.get_collider() is Interactable:
		raycast.get_collider().interact()

func reset() -> void:
	var level_path : String = level.path
	end_level_animation_player.play("CRT_Poweroff")
	await end_level_animation_player.animation_finished
	if is_inside_tree():
		get_tree().change_scene_to_file(level_path)
