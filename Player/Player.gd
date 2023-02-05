extends CharacterBody2D

const SPEED = 100.0

var current_animation = "idle-front-right"
var last_direction = Vector2(1, 1) #front right

var forward_direction = Vector2(0, 1)
var lateral_direction = Vector2(1, 0)

func _physics_process(delta):
	var directionx = Input.get_axis("left", "right")
	var requested_animation = current_animation
	var velocityx = Vector2(0, 0)
	if directionx:
		velocityx = lateral_direction * directionx
		
	var directiony = Input.get_axis("up", "down")
	var velocityy = Vector2(0, 0)
	if directiony:
		velocityy = forward_direction * directiony

	velocity = (velocityx + velocityy).normalized()
	if not directionx and not directiony:
		velocity = Vector2(0, 0)
		
	get_animation()

	velocity *= SPEED
	move_and_slide()


func get_animation():
	var requested_animation = "idle-front-right"
	if velocity.length_squared() < 0.01:
		requested_animation = "idle-front-right"
	elif velocity.x >= 0:
		# Go right
		if velocity.y >= 0:
			#front facing
			requested_animation = "run-front-right"
		else:
			# back facing
			requested_animation = "run-back-right"
	else:
		# Go left
		if velocity.y >= 0:
			#front facing
			requested_animation = "run-front-left"
		else:
			# back facing
			requested_animation = "run-back-left"
	if requested_animation != current_animation:
		current_animation = requested_animation
		$Sprite.animation = current_animation

func enter_dungeon():
	$Sprite.modulate = Color(0.80, 0.64, 1.0)
