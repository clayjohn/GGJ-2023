extends CharacterBody2D

func _ready():
	on_start()

func on_start():
	$Dialogue/DialogueAnimation.play("phase1")
