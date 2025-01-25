class_name Bubble extends RigidBody2D

@export var speed = 10
var levitating_force = Vector2(0, -speed)

# gets called in player.gd
func start(_position, _direction):
	rotation = _direction
	position = _position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	apply_force(levitating_force)

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
