extends Node

signal exit_reached(body)

func _on_exit_body_entered(body):
	exit_reached.emit(body)
