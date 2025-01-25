class_name Bubble extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D

@export var speed = 10

var levitating_force = Vector2(0, -speed)
var isKicked = false
var moveDirection = 0

# gets called in player.gd
func start(_position, _rotation, _direction):
	position = _position
	rotation = _rotation
	moveDirection = _direction

func animationFinished() -> void:
	print("current anim", sprite.animation)
	if sprite.animation == "burst":
		queue_free()
	pass

func getKicked():
	isKicked = true
	linear_velocity = Vector2(0,0)
	constant_force = Vector2(0,0)
	apply_force(Vector2(moveDirection * 20000,0))
	sprite.play("moving")
	await get_tree().create_timer(5.0).timeout
	isKicked = false
	pass

func destroy() -> void:
	sprite.play("burst")
	collisionShape.disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	
	sprite.scale.x = moveDirection
	sprite.animation_finished.connect(animationFinished)
	sprite.play("spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	if !isKicked:
		#print("bubble is levitating...")
		constant_force = levitating_force

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	destroy()
