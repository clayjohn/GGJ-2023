extends Control

# Responsible for managing the game
# Handles loading and unloading of scenes

var levels = [preload("res://Level/Level1.tscn")]

func _ready():
	$Player.position.x = 1044/3.0/2.0
	$Player.position.y = 368/3.0/2.0
	
func switch_level(level: int):
	print("Switching to level ", level)
	var current_level = $Level
	remove_child.call_deferred(current_level)
	current_level.queue_free.call_deferred()
	add_child.call_deferred(levels[level-1].instantiate())
	$Player.position.x = 30
	$Player.position.y = 768/3/2
	
