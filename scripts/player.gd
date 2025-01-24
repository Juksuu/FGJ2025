extends CharacterBody2D

@export var speed = 300.0
@export var jump_speed = -400.0
var bubbleTexture
var isInBubble = false

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
	if isInBubble:
		velocity.y = -speed
	
	move_and_slide()
	
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubbleTexture = find_child("BubbleTexture")
	print("bubble: ",bubbleTexture)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("bubble"):
		isInBubble = !isInBubble
		
	if isInBubble:	
		bubbleTexture.show()
	else:
		bubbleTexture.hide()
		
		
	pass
