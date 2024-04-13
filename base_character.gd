class_name BaseCharacter
extends CharacterBody2D

const DELTA_FACTOR: float = 144

@export var SPEED: float = 700.0
@export var MAX_JUMPS: int = 2
@export var DASH_DISTANCE: float = 250

# TODO replace velocity/decay calculation with curve based calc
@export var JUMP_CURVE: Curve # curve of jump
@export var JUMP_TIME: float = 0.4 # seconds
@export var JUMP_VELOCITY: float = -1700.0 # pixels per second
@export var JUMP_ACCEL: float = 3500 # pixels per second squared
@export var JUMP_ACCEL_DECAY_TIME: float = 0.4 # seconds
@export var DECAY_RATIO: float = 0.07 * DELTA_FACTOR
@export var MIN_DECAY_RATE: float = 0 * DELTA_FACTOR

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping = false
var current_jumps = MAX_JUMPS
var last_jumped: float = Time.get_unix_time_from_system() # seconds
var facing = Vector2.RIGHT
var looking = Vector2.ZERO

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		facing = Vector2.LEFT
	if Input.is_action_just_pressed("ui_right"):
		facing = Vector2.RIGHT
	
	if Input.is_action_just_pressed("ui_dash"):
		var t = create_tween()
		t.tween_property($".", "position", position + facing, 0.1)
		velocity.y = 0
		if current_jumps < MAX_JUMPS:
			current_jumps += 1
	
	if Input.is_action_just_pressed("ui_combo_1"):
		# perform the correct combo action
		comboOne()
		pass

func _physics_process(delta):
	if is_on_floor():
		current_jumps = MAX_JUMPS
	# Add the gravity.
	if not is_on_floor():
		if is_jumping:
			# not my favorite way to do this. need to track time since last
			# jump in order to determine the x axis point to sample the accel
			# curve at.
			var time_since_jump = Time.get_unix_time_from_system() - last_jumped
			if (time_since_jump > JUMP_TIME) or velocity.y >= 0:
				velocity.y = lerp(velocity.y, 0.0, 144*delta)
				is_jumping = false
			else:
				var velocity_change = JUMP_CURVE.sample(time_since_jump / JUMP_ACCEL_DECAY_TIME) * JUMP_ACCEL
				velocity.y += (velocity_change + gravity) * delta
		else:
			velocity.y += gravity * delta
#	if Input.is_action_pressed("ui_up") and is_jumping:
#		# If the user is still holding up, decay jump velocity at specified rate
#		if velocity.y < 0:
#			velocity.y -= min(velocity.y * DECAY_RATIO * delta,\
#				MIN_DECAY_RATE * delta)
#		# If the velocity has decayed to 20%, remove jump status
#		if velocity.y > 0.1*JUMP_VELOCITY:
#			is_jumping = false
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up"):
		print(current_jumps)
		if current_jumps > 0:
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			last_jumped = Time.get_unix_time_from_system()
			current_jumps -= 1
	# If the user releases up button before reaching max jump height, remove
	# jump status, smoothly transition velocity to 10% max and resume normal
	# gravity effects
	if Input.is_action_just_released("ui_up") and is_jumping:
		if velocity.y < 0.1*JUMP_VELOCITY:
			velocity.y = lerp(velocity.y, 0.1*JUMP_VELOCITY, 144*delta)
		is_jumping = false


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func comboOne():
	# Do nothing for base character
	pass
