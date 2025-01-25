extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_to_next_level(levelPos: Vector2) -> void:
	self.position = Vector2(levelPos.x + 1920 / 2, levelPos.y + 1088 / 2)
	get_tree().paused = false
