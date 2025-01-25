extends Node2D
var startScene = preload("res://scenes/test-scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Button1(body: Node2D) -> void:
	pass # Replace with function body.


func StartButton() -> void:
	print("Start Button pressed")
	get_tree().change_scene_to_packed(startScene)
	pass # Replace with function body.


func QuitButton() -> void:
	print("Quit Button pressed")
	pass # Replace with function body.
