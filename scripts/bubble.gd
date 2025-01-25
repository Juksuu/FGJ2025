extends CharacterBody2D

signal on_player_entered

@export var speed = 200

# gets called in player.gd
func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("i was touched by", body)
	if body.name == "Player":
		on_player_entered.emit()
	pass # Replace with function body.

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
