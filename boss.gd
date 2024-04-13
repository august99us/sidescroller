extends RigidBody2D

enum ACTIONS {ENTER, STEP, BACKSTEP, SWIPE, SWING, TURN, IDLE}
const STEP_SIZE = 200 # pixels
const DEFAULT_ACTION_DELAY = 0.2 # seconds

signal quaked

var facing = Vector2.LEFT
var aggro_target: Node2D
var rng = RandomNumberGenerator.new()
var actions_queue = []
var current_action
var wait_timer = 0 # seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	# queue beginning skills
	aggro_target = get_tree().get_first_node_in_group("players")
	
	enter()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# select aggro target
	# queue action to turn to face target
	
	if (current_action != ACTIONS.IDLE):
		return
	if (wait_timer > 0):
		wait_timer -= delta
		return
		
	var deltaXFromTarget = aggro_target.position.x - position.x
	
	if (rng.randi_range(0, 2/delta) == 1):
		stepForward()

func enter():
	# play entering animation
	# currently just a timer
	var t = get_tree().create_timer(5)
	current_action = ACTIONS.ENTER
	t.timeout.connect(enterFinish)

func enterFinish():
	wait_timer = DEFAULT_ACTION_DELAY
	current_action = ACTIONS.IDLE

func stepForward():
	var t = create_tween()
	t.tween_property($".", "position", position + facing * STEP_SIZE, 0.2)
	quaked.emit()
	
func swipe():
	pass
	
func swing():
	pass
	
func charge():
	pass
	

