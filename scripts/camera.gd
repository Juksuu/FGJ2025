extends Node2D

@onready var skyBase = $SkyBase
@onready var skyGrad = $SkyGrad

@export var minHeight = 0
@export var maxHeight = 0

@export var transitionDuration = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var newPosition = self.position
	
	skyBase.material.set_shader_parameter("minHeight", minHeight)
	skyBase.material.set_shader_parameter("maxHeight", maxHeight)
	
	skyGrad.material.set_shader_parameter("minHeight", minHeight)
	skyGrad.material.set_shader_parameter("maxHeight", maxHeight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var height = self.position.abs().y
	skyBase.material.set_shader_parameter("currentHeight", height)
	skyGrad.material.set_shader_parameter("currentHeight", height)

func move_to_next_level(levelPos: Vector2) -> void:
	var pos = Vector2(levelPos.x + 1920 / 2, levelPos.y + 1088 / 2)
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	tween.tween_property(self, "position", pos, transitionDuration)
	tween.tween_callback(on_transition_tween_done)
	
func on_transition_tween_done() -> void:
	get_tree().paused = false
