extends Camera2D
class_name ShakeCamera2D

@export var decay = 2  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(32, 24)  # Maximum hor/ver shake in pixels.
#@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
@export var target: NodePath  # Assign the node this camera will follow.

var trauma = 0.0  # Current shake strength.
var trauma_power = 1.5 # Trauma exponent. Use [2, 3].

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	#rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
