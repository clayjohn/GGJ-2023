extends Control

# Responsible for managing the game
# Handles loading and unloading of scenes

var levels = [preload("res://Level/Level1.tscn"),
			preload("res://Level/Level2.tscn"),
			preload("res://Level/Level3.tscn"),
			preload("res://Level/Level4.tscn"),
			preload("res://Enemies/Boss/BossRoom.tscn")]
var next_level: int

func _ready():
	$Player.position.x = 1044/3.0/2.0
	$Player.position.y = 368/3.0/2.0
	next_level = 1
	
func get_player():
	return $Player
	
func switch_level():
	print("Switching to level ", next_level)
	if next_level == 1: # Fade to black
		$AnimationPlayer.play("FadeOut")
	else:
		_switch_level(next_level)

func _switch_level(level: int):
	var current_level = $Level
	$Player.enter_dungeon()
	remove_child.call_deferred(current_level)
	current_level.queue_free.call_deferred()
	add_child.call_deferred(levels[level-1].instantiate())
	print(next_level)
	next_level += 1
	
func _switch_level_slide(level: int):
	var current_level = $Level
	$Player.enter_dungeon()
	var upcoming_level = levels[level-1].instantiate()
	add_child.call_deferred(upcoming_level)
	print(next_level)
	next_level += 1

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		$AnimationPlayer.play("FadeIn")
		_switch_level(next_level)
