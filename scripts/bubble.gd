class_name Bubble extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var collisionShape = $CollisionShape2D

@export var verticalSpeed = -50
@export var horizontalSpeed = 400

var isKicked = false
var moveDirection = 0

# gets called in player.gd
func start(_position, _rotation, _direction):
	position = _position
	rotation = _rotation
	moveDirection = _direction

func animationFinished(name: String) -> void:
	print("current anim", name)
	if name == "burst":
		queue_free()

func getKicked():
	velocity.x = moveDirection * horizontalSpeed
	animationPlayer.play("move")

func destroy() -> void:
	print("destroy bubbel")
	animationPlayer.play("burst")
	collisionShape.disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale.x = moveDirection
	animationPlayer.animation_finished.connect(animationFinished)
	animationPlayer.play("spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	if velocity.x == 0:
		velocity.y = verticalSpeed
	else:
		velocity.y = 0

	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() is not Player:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			move_and_collide(reflect)
			

		
	var normal = velocity.normalized()
	if normal.x != 0:
		sprite.scale.x = normal.x
		
func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	destroy()
