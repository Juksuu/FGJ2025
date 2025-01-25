class_name Player extends CharacterBody2D

signal player_entering_new_level(levelPos: Vector2)

@export var speed = 300.0
@export var jump_speed = -400.0
var bubbleTexture
var isInBubble = false
var hasBubble = true
var Bubble = preload("res://scenes/bubble.tscn")
var bubbleSpeed = 200

var currentLevel

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func bubbleHit():
	print("Player got hit by a bubble.")
	isInBubble = true
	await get_tree().create_timer(1.0).timeout
	isInBubble = false
	hasBubble = true
	pass

func spawnBubble():
	hasBubble = false
	var b = Bubble.instantiate()
	b.start($marker.global_position, rotation)
	get_tree().root.add_child(b)
	pass

func kick():
	var collisions = $KickArea.get_overlapping_bodies()
	for i in collisions:
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
		velocity.y = jump_speed

	# shoot input
	if Input.is_action_just_pressed("bubble") and hasBubble:
		spawnBubble()
	pass

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
			collisionObject.free()
			bubbleHit()
	pass

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
	pass

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
