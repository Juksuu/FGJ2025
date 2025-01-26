class_name Bubble extends CharacterBody2D
signal hitPlayer
signal bubbleExpired

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var collisionShape = $CollisionShape2D
@onready var collisionTop = $CollisionShape2D2
@onready var audio = $Audio

@export var verticalSpeed = -100
@export var horizontalSpeed = 400

var isKicked = false
var isStomped = false
var exists = false
var stompTimer = 2
var floatingTimer = 10
var moveDirection = 0

var bubbleMoveTimer = 0

# gets called in player.gd
func start(_position, _rotation, _direction):
	position = _position
	rotation = _rotation
	moveDirection = _direction

func animationFinished(name: String) -> void:
	print("current anim", name)
	if name == "burst":
		queue_free()
	if name == "spawn":
		exists = true

func getKicked():
	isKicked = true
	isStomped = false
	floatingTimer = 10
	velocity.x = moveDirection * horizontalSpeed
	animationPlayer.play("move")

func destroy() -> void:
	print("destroy bubbel")
	animationPlayer.play("burst")
	audio.playBubblePop()
	collisionShape.disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale.x = moveDirection
	animationPlayer.animation_finished.connect(animationFinished)
	animationPlayer.play("spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isStomped:
		stompTimer -= delta
		if stompTimer <=0:
			bubbleExpired.emit()
			destroy()
	elif not isStomped and not isKicked and floatingTimer > 0 and exists:
		floatingTimer -= delta

	bubbleMoveTimer -= delta
	if animationPlayer.is_playing() and animationPlayer.current_animation == "move":
		if bubbleMoveTimer <=0:
			bubbleMoveTimer = 0.3
			audio.playBubbleMove()

func _physics_process(delta):
	if velocity.x == 0 and not isStomped:
		#if floatingTimer <= 0:
		var modifiedFloat =  verticalSpeed * ((10 - floatingTimer) / 10)
		velocity.y = clamp(modifiedFloat, verticalSpeed, 0)
	else:
		velocity.y = 0

	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() is Player:
			if collision.get_local_shape() == collisionTop and velocity.x == 0:
				print("MURDER")
				isStomped = true
				floatingTimer = 10
				animationPlayer.play("jump")
			else:
				print("KILL")
				hitPlayer.emit(self)
		elif collision.get_collider() is not Player:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			move_and_collide(reflect)



	var normal = velocity.normalized()
	if normal.x != 0:
		sprite.scale.x = normal.x

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	destroy()

func _top_collider():
	return collisionTop
