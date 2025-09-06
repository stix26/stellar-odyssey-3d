extends CharacterBody3D
class_name Player

# Movement constants
const SPEED = 8.0
const JUMP_VELOCITY = 12.0
const DASH_SPEED = 20.0
const DASH_DURATION = 0.3
const ACCELERATION = 10.0
const FRICTION = 8.0
const AIR_ACCELERATION = 5.0
const MOUSE_SENSITIVITY = 0.002

# Camera setup
@onready var camera_controller = $CameraController
@onready var camera_3d = $CameraController/SpringArm3D/Camera3D
@onready var spring_arm = $CameraController/SpringArm3D
@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D
@onready var dash_particles = $DashParticles
@onready var jump_particles = $JumpParticles
@onready var landing_particles = $LandingParticles
# Animation player removed for stability

# State variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector3.ZERO
var was_on_floor = false
var coyote_time = 0.1
var coyote_timer = 0.0
var jump_buffer_time = 0.1
var jump_buffer_timer = 0.0

# Camera variables
var camera_rotation_x = 0.0
var camera_shake_intensity = 0.0
var camera_shake_timer = 0.0

func _ready():
	# Setup camera
	spring_arm.spring_length = 8.0
	spring_arm.collision_mask = 1
	
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Setup complete
	print("Player initialized")

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse movement rotates the player
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Vertical mouse movement rotates the camera
		camera_rotation_x -= event.relative.y * MOUSE_SENSITIVITY
		camera_rotation_x = clamp(camera_rotation_x, -PI/2, PI/2)
		camera_controller.rotation.x = camera_rotation_x
	
	# Toggle pause menu
	if event.is_action_pressed("ui_cancel"):
		show_pause_menu()

func _physics_process(delta):
	handle_gravity(delta)
	handle_jump_input(delta)
	handle_dash(delta)
	handle_movement(delta)
	handle_camera_shake(delta)
	handle_animations()
	
	# Store floor state for advanced landing detection
	var was_in_air = not was_on_floor
	was_on_floor = is_on_floor()
	
	# Advanced landing detection and scoring
	if was_in_air and is_on_floor():
		handle_landing(velocity.y)
	
	# Death zone detection
	if global_position.y < -50:  # Fell off the world
		trigger_death()
	
	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

func handle_jump_input(delta):
	# Jump buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta
	
	# Execute jump
	if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0):
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		create_jump_effect()

func handle_dash(delta):
	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()

func start_dash():
	var input_dir = get_input_direction()
	if input_dir.length() > 0:
		dash_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_particles.emitting = true
		camera_shake(0.5, 0.2)

func end_dash():
	is_dashing = false
	dash_particles.emitting = false

func handle_movement(delta):
	var input_dir = get_input_direction()
	
	if is_dashing:
		# Override movement during dash
		velocity.x = dash_direction.x * DASH_SPEED
		velocity.z = dash_direction.z * DASH_SPEED
		return
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_velocity = Vector2.ZERO
	var accel = ACCELERATION if is_on_floor() else AIR_ACCELERATION
	
	if direction:
		target_velocity.x = direction.x * SPEED
		target_velocity.y = direction.z * SPEED
	
	# Smooth acceleration/deceleration
	var current_velocity = Vector2(velocity.x, velocity.z)
	if direction:
		current_velocity = current_velocity.move_toward(target_velocity, accel * delta)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity.x = current_velocity.x
	velocity.z = current_velocity.y

func get_input_direction() -> Vector2:
	var input_dir = Vector2()
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_forward"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.y += 1
	return input_dir.normalized()

func handle_camera_shake(delta):
	if camera_shake_timer > 0:
		camera_shake_timer -= delta
		var shake_amount = camera_shake_intensity * (camera_shake_timer / 0.5)
		camera_3d.rotation.x = randf_range(-shake_amount, shake_amount)
		camera_3d.rotation.y = randf_range(-shake_amount, shake_amount)
	else:
		camera_3d.rotation = Vector3.ZERO

func camera_shake(intensity: float, duration: float):
	camera_shake_intensity = intensity
	camera_shake_timer = duration

func handle_animations():
	# Animation system disabled for stability - using particle effects instead
	pass

func create_jump_effect():
	jump_particles.emitting = true
	AudioManager.play_sound("jump")

func handle_landing(fall_velocity: float):
	var landing_data = calculate_landing_data(fall_velocity)
	
	# Award points through ScoreManager
	var points_earned = ScoreManager.calculate_landing_score(landing_data)
	
	# Visual and audio feedback
	create_landing_effect(landing_data)
	
	print("Landing scored: " + str(points_earned) + " points!")

func calculate_landing_data(fall_velocity: float) -> Dictionary:
	# AI-powered landing analysis
	var platform_center = find_nearest_platform_center()
	var distance_to_center = global_position.distance_to(platform_center)
	
	# Calculate impact angle
	var impact_angle = rad_to_deg(velocity.normalized().angle_to(Vector3.DOWN))
	
	return {
		"fall_height": abs(fall_velocity),
		"landing_speed": velocity.length(),
		"landing_velocity": velocity,
		"impact_angle": impact_angle,
		"platform_center_distance": distance_to_center,
		"was_dashing": is_dashing
	}

func find_nearest_platform_center() -> Vector3:
	# AI raycasting to find platform center
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position + Vector3(0, 1, 0),
		global_position + Vector3(0, -10, 0)
	)
	query.collision_mask = 1  # World layer
	
	var result = space_state.intersect_ray(query)
	if result:
		return result["position"]
	return global_position

func create_landing_effect(landing_data: Dictionary):
	landing_particles.emitting = true
	
	# Intensity based on landing quality
	var intensity = landing_data["landing_speed"] / 10.0
	camera_shake(intensity * 0.1, 0.15)
	
	# Different sounds for different landing types
	if ScoreManager.is_perfect_landing(landing_data):
		AudioManager.play_sound("perfect_land")
	else:
		AudioManager.play_sound("land")

func trigger_death():
	print("PLAYER DEATH TRIGGERED!")
	
	# Disable controls
	set_physics_process(false)
	set_process_input(false)
	
	# Death effects
	create_death_effects()
	
	# Notify systems
	ScoreManager.player_died()
	GameManager.player_death()

func create_death_effects():
	# Dramatic death particle explosion
	var explosion_particles = GPUParticles3D.new()
	get_parent().add_child(explosion_particles)
	explosion_particles.global_position = global_position
	explosion_particles.amount = 200
	explosion_particles.emitting = true
	
	# Screen shake
	camera_shake(3.0, 2.0)
	
	# Death sound
	AudioManager.play_sound("death")
	
	# Fade out effect
	var tween = create_tween()
	tween.tween_property(mesh_instance, "modulate:a", 0.0, 1.0)

func show_pause_menu():
	# Create pause menu popup
	var pause_dialog = AcceptDialog.new()
	pause_dialog.title = "GAME PAUSED - ESC to Resume"
	pause_dialog.size = Vector2(450, 350)
	
	var vbox = VBoxContainer.new()
	pause_dialog.add_child(vbox)
	
	var title_label = Label.new()
	title_label.text = "STELLAR ODYSSEY PAUSED"
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	var instruction_label = Label.new()
	instruction_label.text = "Press ESC anytime to pause/resume"
	instruction_label.add_theme_font_size_override("font_size", 14)
	instruction_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(instruction_label)
	
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Resume button
	var resume_button = Button.new()
	resume_button.text = "▶ RESUME GAME"
	resume_button.add_theme_font_size_override("font_size", 16)
	resume_button.pressed.connect(func(): pause_dialog.queue_free())
	vbox.add_child(resume_button)
	
	# Main menu button (make it prominent)
	var main_menu_button = Button.new()
	main_menu_button.text = "🏠 MAIN MENU"
	main_menu_button.add_theme_font_size_override("font_size", 18)
	main_menu_button.pressed.connect(func(): 
		pause_dialog.queue_free()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	vbox.add_child(main_menu_button)
	
	# Level select button
	var level_select_button = Button.new()
	level_select_button.text = "📋 SELECT DIFFERENT LEVEL"
	level_select_button.add_theme_font_size_override("font_size", 16)
	level_select_button.pressed.connect(func(): 
		pause_dialog.queue_free()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/LevelSelector.tscn")
	)
	vbox.add_child(level_select_button)
	
	# Restart level button
	var restart_button = Button.new()
	restart_button.text = "🔄 RESTART LEVEL"
	restart_button.add_theme_font_size_override("font_size", 16)
	restart_button.pressed.connect(func(): 
		pause_dialog.queue_free()
		get_tree().paused = false
		GameManager.restart_current_level()
	)
	vbox.add_child(restart_button)
	
	get_tree().current_scene.add_child(pause_dialog)
	pause_dialog.popup_centered()
	
	# Pause the game
	get_tree().paused = true
	pause_dialog.tree_exiting.connect(func(): get_tree().paused = false)
