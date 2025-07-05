extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var level : Level = $".."
@onready var switch_timer: Timer = $Switch_Timer
@onready var end_level_animation_player: AnimationPlayer = $Camera3D/HUD/End_Level_Effect/End_Level_Animation_Player

const ACCEL : float = 1.0
const SPRINT_SPEED: float = 7.5
const WALK_SPEED : float = 5.0
const JUMP_VELOCITY : float = 3.0 # Higher than this breaks the tutorial cause you can just skip jumps...
const CAMERA_SENS : float = 0.001 # Camera sensitivity...

const SWITCH_TIME : float = 1.0 # Min time between dimension swaps

var is_mouse_locked : bool = false
var can_toggle_dimension : bool = true


func _ready() -> void:
	_toggle_dimension()
	switch_timer.timeout.connect(func(): can_toggle_dimension = true)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Shift_Dimension") and can_toggle_dimension:
		can_toggle_dimension = false
		level._shift_dimension()
		_toggle_dimension()
	elif switch_timer.is_stopped(): switch_timer.start(SWITCH_TIME)
	
	if Input.is_action_just_pressed("Interact"): _try_interacting()
	
	if Input.is_action_just_pressed("Escape"): _lock_mouse(not is_mouse_locked)
	
	if Input.is_action_just_pressed("Reset"): reset()
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var speed = SPRINT_SPEED if Input.is_action_pressed("Sprint") else WALK_SPEED
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, ACCEL)
		velocity.z = move_toward(velocity.z, direction.z * speed, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		camera.rotation.x = clampf(camera.rotation.x - event.relative.y * CAMERA_SENS, -1.5, 1.75)
	elif event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed(): _lock_mouse(true)

func _lock_mouse(val : bool) -> void:
	is_mouse_locked = val
	if is_mouse_locked: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

enum {DUSK, DAWN}
var current_dimension := DUSK
func _toggle_collision_mask(val) -> void:
	if val == DUSK: collision_layer = 3; collision_mask = 3 # Collision layer is handled as binary (layers 1 + 2 = 0011 -> 3)
	elif val == DAWN: collision_layer = 5; collision_mask = 5# 1 + 3 = 101 -> 5

func _toggle_dimension() -> void:
	if current_dimension == DUSK: current_dimension = DAWN; _set_skybox(DAWN); _toggle_collision_mask(DAWN)
	elif current_dimension == DAWN: current_dimension = DUSK; _set_skybox(DUSK); _toggle_collision_mask(DUSK)

const DAWN_SKYBOX = preload("res://Assets/Skyboxes/Dawn_Skybox.tres")
const DUSK_SKYBOX = preload("res://Assets/Skyboxes/Dusk_Skybox.tres")
@onready var world_environment: WorldEnvironment = $Camera3D/WorldEnvironment

func _set_skybox(val) -> void:
	if val == DAWN: world_environment.environment = DAWN_SKYBOX
	elif val == DUSK: world_environment.environment = DUSK_SKYBOX

func _try_interacting() -> void:
	if raycast.is_colliding() and raycast.get_collider() is Interactable: raycast.get_collider().interact()

func reset() -> void:
	end_level_animation_player.play("CRT_Poweroff")
	await end_level_animation_player.animation_finished
	get_tree().change_scene_to_file(level.path)
