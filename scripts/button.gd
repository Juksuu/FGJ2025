extends Area2D
@export var text = "Default text"

signal playerTouched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = "[center]"+text+"[center]"
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# print("player collided with Button.")
		playerTouched.emit()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
