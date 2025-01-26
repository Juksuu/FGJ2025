class_name Player extends CharacterBody2D

signal player_entering_new_level(levelPos: Vector2)

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $playerTexture
@onready var marker = $marker
@onready var kickArea = $KickArea
@onready var bubbleTexture = $BubbleTexture
@onready var audio = $Audio

@onready var global = $"/root/Globals"

@export var speed = 300.0
@export var jump_speed = -400.0
@export var mass: float = 1.00 # abstract value to dampen the floatiness in jump 
@export var acceleration = 600
@export var deceleration = 800

var walkAudioTimer = 0

var isInBubble = false

var Bubble = preload("res://scenes/bubble.tscn")
var bubbleSpeed = 200

var bubbleInUse: Bubble

var currentLevel

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func bubbleHit(bubble):
	print("Player got hit by a bubble.")
	bubble.destroy()
	animationPlayer.play("bubble")
	isInBubble = true
	bubbleInUse = null
	await get_tree().create_timer(1.0).timeout
	isInBubble = false
	pass

func spawnBubble():
	if bubbleInUse:
		bubbleInUse.destroy()
		bubbleInUse = null
		
	var b = Bubble.instantiate()
	b.start(marker.global_position, rotation, sprite.scale.x)
	b.hitPlayer.connect(bubbleHit)
	b.bubbleExpired.connect(clear_bubble_target)
	get_tree().root.add_child(b)
	animationPlayer.play("blowBubble")
	
	global.useBubbel()
	
	bubbleInUse = b

func clear_bubble_target():
	bubbleInUse = null
	return

func animationFinished(name: String):
	if name == "punch":
		var collisions = kickArea.get_overlapping_bodies()
		for collider in collisions:
			if collider is MainMenuButton:
				collider.playerKicked()

func checkBubbleHit() -> void:
		var collisions = kickArea.get_overlapping_bodies()
		for collider in collisions:
			if collider is Bubble:
				collider.getKicked()

func handleInput(delta):
	if Input.is_action_just_pressed("kick"):
		print("SUPER KICK")
		animationPlayer.play("punch")
		audio.playPunch()
		checkBubbleHit()

	# Handle horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x = move_toward(velocity.x, -speed, acceleration * delta)
	elif Input.is_action_pressed("right"):
		velocity.x = move_toward(velocity.x, speed, acceleration * delta)
	else:
		# Decelerate when no input
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	# Handle Jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		animationPlayer.play("jump")
		audio.playJump()
		velocity.y = jump_speed

	# shoot input
	if Input.is_action_just_pressed("bubble") and is_on_floor():
		spawnBubble()

	# Handle animation state changing
	var resetAnims = ["walk", "bubble"]
	
	var direction = Input.get_axis("left","right")
	if velocity.y > 0:
		animationPlayer.play("bubble")
	if direction != 0:
		sprite.set_scale(Vector2(direction, 1))
		marker.position.x = direction * 96
		kickArea.position.x = direction * 65
		if velocity.y == 0:
			animationPlayer.play("walk")
	elif direction == 0 and velocity.y == 0 and animationPlayer.is_playing() and resetAnims.find(animationPlayer.current_animation) != -1:
		animationPlayer.play("RESET")

func _physics_process(delta):
	handleInput(delta)

	# inside and outside bubble gravity
	if isInBubble:
		velocity.y = -speed
	else:
		velocity.y += gravity * mass * delta 

	move_and_slide()

	# collision
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collisionObject = collision.get_collider()
		if collisionObject is Bubble and !isInBubble:
			if collision.get_collider_shape() == collisionObject._top_collider():
				continue
			else:
				collisionObject.destroy()
				bubbleHit(collisionObject)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer.animation_finished.connect(animationFinished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isInBubble:
		bubbleTexture.show()
	else:
		bubbleTexture.hide()
	
	walkAudioTimer -= delta
	if animationPlayer.is_playing() and animationPlayer.current_animation == "walk":
		if walkAudioTimer <=0:
			walkAudioTimer = 0.4
			audio.playWalk()

func on_new_level_entry(level: Level) -> void:
	print("on new level entry")
	#self.set_collision_layer_value(3, false)
	self.set_collision_mask_value(3, false)
	
	velocity.y = jump_speed

	player_entering_new_level.emit(level.position)

func on_new_level_entered(level: Level) -> void:
	#self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(3, true)

	if self.currentLevel:
		self.currentLevel.set_monitor_entry(true)

	level.set_monitor_entry(false)
	self.currentLevel = level

func on_new_final_level_entry(level: FinalLevel) -> void:
	#self.set_collision_layer_value(3, false)
	self.set_collision_mask_value(3, false)
	
	velocity.y = jump_speed

	player_entering_new_level.emit(level.position)

func on_new_final_level_entered(level: FinalLevel) -> void:
	#self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(3, true)

	if self.currentLevel:
		self.currentLevel.set_monitor_entry(true)

	level.set_monitor_entry(false)
	self.currentLevel = level
