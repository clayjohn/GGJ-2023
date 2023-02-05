extends Node

signal exit_reached(body)

var dead_enemies = 0
@export var dead_enemies_to_unlock = 7

func _on_exit_body_entered(body):
	exit_reached.emit(body)

func _on_enemy_has_died():
	dead_enemies += 1
	if dead_enemies >= dead_enemies_to_unlock:
		$AnimationPlayer.play("OpenExit")
