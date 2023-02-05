extends Node2D

var player: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_player()

func _on_exit_body_entered(body):
	print(body)
	if body == player:
		get_parent().switch_level()
