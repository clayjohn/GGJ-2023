extends Control

# Responsible for managing the game
# Handles loading and unloading of scenes

var levels = [preload("res://Level/Level1.tscn"),
			preload("res://Level/Level2.tscn"),
			preload("res://Level/Level3.tscn"),
			preload("res://Level/Level5.tscn"),]
var next_level: int
var current_level
var upcoming_level

func _ready():
	$Player.position.x = 224
	$Player.position.y = 128
	next_level = 1
	current_level = $Level
	current_level.exit_reached.connect(switch_level)
	
func get_player():
	return $Player
	
func switch_level(body):
	if body != $Player: return

	if next_level == 1: # Fade to black
		$AnimationPlayer.play("FadeOut")
	else:
		_switch_level_slide(next_level)

func _switch_level(level: int):
	$Player.enter_dungeon()
	current_level.queue_free.call_deferred()
	upcoming_level = levels[level-1].instantiate()
	add_child.call_deferred(upcoming_level)
	current_level = upcoming_level
	current_level.exit_reached.connect(switch_level)
	next_level += 1
	
func _switch_level_slide(level: int):
	$Player.freeze_player.call_deferred()
	upcoming_level = levels[level-1].instantiate()
	upcoming_level.position.y = 256
	add_child.call_deferred(upcoming_level)
	$AnimationPlayer.play("Slide")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		$AnimationPlayer.play("FadeIn")
		_switch_level(next_level)
	elif anim_name == "Slide":
		current_level.visible = false
		current_level.queue_free.call_deferred()
		$Player.enter_dungeon.call_deferred()
		position.y = 0
		upcoming_level.position.y = 0
		current_level = upcoming_level
		current_level.exit_reached.connect(switch_level)
		next_level += 1
