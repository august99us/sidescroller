extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("trees")
	$Sprite2D.scale.y = 0.1
	var t = create_tween()
	t.tween_property($"Sprite2D", "scale", Vector2($Sprite2D.scale.x, 1), 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
