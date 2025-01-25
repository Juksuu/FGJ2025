class_name Level extends Node2D

@onready var player: Player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_monitor_entry(value: bool) -> void:
	for child in get_children():
		if is_instance_of(child, Area2D):
			child.set_deferred("monitoring", value)

func _on_level_entry_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.on_new_level_entry(self)


func _on_level_entry_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player.on_new_level_entered(self)
