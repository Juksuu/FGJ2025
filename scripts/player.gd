extends CharacterBody2D

@export var speed = 300.0
@export var jump_speed = -400.0
var bubbleTexture
var isInBubble = false
var Bubble = preload("res://scenes/bubble.tscn")
var bubbleSpeed = 200

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	
	# Get the input direction.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
	# Handle Jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_speed
	
	# shoot input
	if Input.is_action_just_pressed("shoot"):
		shoot()
	pass

func shoot():
	var b = Bubble.instantiate()
	b.start($marker.global_position, rotation)
	get_tree().root.add_child(b)
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
#		print("Collided with: ", collision.get_collider().name)
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubbleTexture = find_child("BubbleTexture")
	print("bubble: ",bubbleTexture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("bubble"):
		isInBubble = !isInBubble

	if isInBubble:
		bubbleTexture.show()
	else:
		bubbleTexture.hide()
	pass

func on_new_level_entry() -> void:
	self.set_collision_layer_value(3, false)
	self.set_collision_mask_value(3, false)

func on_new_level_entered() -> void:
	self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(3, true)
		
		
	pass


func _on_bubble_on_player_entered() -> void:
	print("entered bubble")
	pass # Replace with function body.
