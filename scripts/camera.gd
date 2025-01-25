extends Node2D

@onready var skyBase = $SkyBase
@onready var skyGrad = $SkyGrad

const MIN_HEIGHT = 0
const MAX_HEIGHT = 1088

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skyBase.material.set_shader_parameter("minHeight", MIN_HEIGHT)
	skyBase.material.set_shader_parameter("maxHeight", MAX_HEIGHT)
	
	skyGrad.material.set_shader_parameter("minHeight", MIN_HEIGHT)
	skyGrad.material.set_shader_parameter("maxHeight", MAX_HEIGHT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var height = self.position.abs().y
	skyBase.material.set_shader_parameter("currentHeight", height)
	skyGrad.material.set_shader_parameter("currentHeight", height)

func move_to_next_level(levelPos: Vector2) -> void:
	self.position = Vector2(levelPos.x + 1920 / 2, levelPos.y + 1088 / 2)
	get_tree().paused = false
