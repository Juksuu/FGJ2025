class_name FinalLevel extends Node2D

@onready var player: Player = $"../Player"
@onready var global = $"/root/Globals"

@onready var timeSpent = $TimeSpent
@onready var bubbelsUsed = $BubbelsUsed

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

func updateStats() -> void:
	global.gameEnded()
	var time = global.getTotalTimeSpentSeconds()
	var minutes = floor(time / 60)
	var seconds = time % 60
	
	bubbelsUsed.text = "[center]You used " + str(global.bubbelsUsed) + " bubbels[/center]"
	timeSpent.text = "[center]It took " + str(minutes) + " minutes and " + str(seconds) + " seconds to complete the game[/center]"

func _on_level_entry_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		updateStats()
		player.on_new_final_level_entry(self)


func _on_level_entry_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player.on_new_final_level_entered(self)
