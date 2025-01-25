class_name MainMenuButton extends StaticBody2D
@export var text = "Default text"

signal playerTouched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = "[center]"+text+"[center]"
	pass # Replace with function body.


func playerKicked() -> void:
	playerTouched.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
