class_name Player extends CharacterBody2D

signal player_entering_new_level(levelPos: Vector2)

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $playerTexture
@onready var marker = $marker
@onready var kickArea = $KickArea

@export var speed = 300.0
@export var jump_speed = -400.0
var bubbleTexture
var isInBubble = false

var Bubble = preload("res://scenes/bubble.tscn")
var bubbleSpeed = 200

var bubbleInUse: Bubble

var currentLevel

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func bubbleHit():
	print("Player got hit by a bubble.")
	isInBubble = true
	bubbleInUse = null
	animationPlayer.play("bubble")
	await get_tree().create_timer(1.0).timeout
	isInBubble = false
	pass

func spawnBubble():
	if bubbleInUse:
		bubbleInUse.destroy()
		bubbleInUse = null
		
	var b = Bubble.instantiate()
	b.start(marker.global_position, rotation, sprite.scale.x)
	get_tree().root.add_child(b)
	animationPlayer.play("blowBubble")
	
	bubbleInUse = b

func kick():
	animationPlayer.play("punch")
	var collisions = kickArea.get_overlapping_bodies()
	for i in collisions:
		if i is Bubble:
			i.getKicked()
			print("Kick connected with ", i.name)
	print("Kick done")
	pass

func get_input():
	if Input.is_action_just_pressed("kick"):
		print("SUPER KICK")
		kick()


	# Get the input direction.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed

	# Handle Jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		animationPlayer.play("jump")
		velocity.y = jump_speed

	# shoot input
	if Input.is_action_just_pressed("bubble") and is_on_floor():
		spawnBubble()

	# Handle animation state changing
	var resetAnims = ["walk", "bubble"]
	
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
	get_input()

	# inside and outside bubble gravity
	if isInBubble:
		velocity.y = -speed
	else:
		velocity.y += gravity * delta

	move_and_slide()

	# collision
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collisionObject = collision.get_collider()
		if collisionObject is Bubble and !isInBubble:
			collisionObject.destroy()
			bubbleHit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubbleTexture = find_child("BubbleTexture")
	print("bubble: ",bubbleTexture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if isInBubble:
		bubbleTexture.show()
	else:
		bubbleTexture.hide()

func on_new_level_entry(level: Level) -> void:
	self.set_collision_layer_value(3, false)
	self.set_collision_mask_value(3, false)

	player_entering_new_level.emit(level.position)

func on_new_level_entered(level: Level) -> void:
	self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(3, true)

	if self.currentLevel:
		self.currentLevel.set_monitor_entry(true)

	level.set_monitor_entry(false)
	self.currentLevel = level


func _on_bubble_on_player_entered() -> void:
	print("entered bubble")
	pass # Replace with function body.
