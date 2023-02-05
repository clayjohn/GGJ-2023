extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	print("Enter the dungeon") # Replace with function body.
	get_parent().switch_level()
