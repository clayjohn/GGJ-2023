extends CharacterBody2D

const SPEED = 100.0

var current_animation = "idle-front-right"

var forward_direction = Vector2(-0.707, 0.707)
var lateral_direction = Vector2(0.707, 0.707)

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

	velocity *= SPEED
	move_and_slide()


func enter_dungeon():
	$Sprite.modulate = Color(0.80000001192093, 0.63921570777893, 0.98823529481888)
