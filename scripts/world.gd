extends Node2D

@onready var camera = $Camera
@onready var player = $Player
@onready var audio = $Audio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.startMusic()
	player.player_entering_new_level.connect(player_entering_new_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func player_entering_new_level(levelPos: Vector2) -> void:
	get_tree().paused = true
	camera.move_to_next_level(levelPos)
