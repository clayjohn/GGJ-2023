extends CharacterBody2D

func _ready():
	pass

func on_start():
	$Dialogue/DialogueAnimation.play("phase1")
