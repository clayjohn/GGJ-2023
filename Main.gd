extends Control

# Responsible for managing the game
# Handles loading and unloading of scenes

var levels = []
var next_level: int
var current_level
var upcoming_level

var menu_dialogue_finished = false
var level1_dialogue_finished = false
var level2_dialogue_finished = false
var level3_dialogue_finished = false
var boss_dialogue_finished = false

func _ready():
	levels.push_back($Level)
	levels.push_back(load("res://Level/Level1.tscn").instantiate())
	levels.push_back(load("res://Level/Level2.tscn").instantiate())
	levels.push_back(load("res://Level/Level3.tscn").instantiate())
	levels.push_back(load("res://Level/Level4.tscn").instantiate())
	$Player.position.x = 224
	$Player.position.y = 128
	$Player.get_born()
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
	if level > 0:
		$Player.enter_dungeon()
#	current_level.queue_free.call_deferred()
	current_level.exit_reached.disconnect(switch_level)
	remove_child.call_deferred(current_level)
	upcoming_level = levels[level]
	upcoming_level.position.y = 0 #reset if it has slid before
	add_child.call_deferred(upcoming_level)
	current_level = upcoming_level
	current_level.exit_reached.connect(switch_level)
	next_level += 1
	
func _switch_level_slide(level: int):
	$Player.freeze_player.call_deferred()
	upcoming_level = levels[level]
	upcoming_level.position.y = 256
	add_child.call_deferred(upcoming_level)
	$AnimationPlayer.play("Slide")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		$AnimationPlayer.play("FadeIn")
		_switch_level(next_level)
	elif anim_name == "Slide":
		current_level.visible = false
#		current_level.queue_free.call_deferred()
		remove_child.call_deferred(current_level)
		$Player.enter_dungeon.call_deferred()
		position.y = 0
		upcoming_level.position.y = 0
		current_level = upcoming_level
		current_level.exit_reached.connect(switch_level)
		next_level += 1
	else:
		if anim_name.get_slice("-", 1) == "dialogue":
			$Player.thaw_player()
		

func _on_player_fully_born():
	if not menu_dialogue_finished:
		$AnimationPlayer.play("menu-dialogue")
		menu_dialogue_finished = true
	else:
		$Player.thaw_player()

func _on_player_entered_level():
	match next_level:
		1:
			pass # Menu is handled on its own
		2:
			if not level1_dialogue_finished:
				$Player.freeze_player()
				$AnimationPlayer.play("level1-dialogue")
				level1_dialogue_finished = true
		3:
			if not level2_dialogue_finished:
				$Player.freeze_player()
				$AnimationPlayer.play("level2-dialogue")
				level2_dialogue_finished = true
		4:
			if not level3_dialogue_finished:
				$Player.freeze_player()
				$AnimationPlayer.play("level3-dialogue")
				level3_dialogue_finished = true
		5:
			if not boss_dialogue_finished:
				$Player.freeze_player()
				$AnimationPlayer.play("boss-dialogue")
				boss_dialogue_finished = true


func _on_player_died():
	$Player.position.x = 224
	$Player.position.y = 128
	$Player/HUDLayer/Control/Life.visible = true
	$Player.get_born.call_deferred()
	next_level = 0
	call_deferred("_switch_level",next_level)
