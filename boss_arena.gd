extends Node2D

const TREE = preload("res://tree.tscn")
const ARENA_SIZE = 1920

var shakeCamera : ShakeCamera2D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Boss.quaked.connect(shake)
	shakeCamera = get_node("Character/DefaultCamera")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shake():
	shakeCamera.add_trauma(1)
	spawnTree()
	
func spawnTree():
	if (get_tree().get_nodes_in_group("trees").size() < 4):
		var spawnPosition = rng.randi_range(ARENA_SIZE * 0.1, ARENA_SIZE * 0.9)
		var newTree = TREE.instantiate()
		get_parent().add_child(newTree)
		newTree.position = Vector2(spawnPosition, 950)
