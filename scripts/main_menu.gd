extends Node2D

@onready var audio = $Audio

var startScene = preload("res://scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.startMusic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func StartButton() -> void:
	print("Start Button pressed")
	get_tree().change_scene_to_packed(startScene)


func QuitButton() -> void:
	print("Quit Button pressed")
	get_tree().quit()
