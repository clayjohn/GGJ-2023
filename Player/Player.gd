extends CharacterBody2D

const SPEED = 100.0

# Used to validate animation and only set when changed
var current_animation = "idle-front-right"
# Used to remember what direction you were running before stopping
var last_direction = Vector2(1, 1) #front right
var locked = false

var attacking = false
 # use this so spamming attack feels good
var attack_queued = false

var forward_direction = Vector2(0, 1)
var lateral_direction = Vector2(1, 0)

func _physics_process(delta):
	if locked: return
	
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

func _input(event):
	if event.is_action_pressed("attack") and not attacking:
		$Sprite.animation = "attack-light" + get_animation_direction(last_direction)
		attacking = true
		$Attack.rotation = get_attack_rotation()
		print(get_attack_rotation())
		attack_surroundings()
	elif event.is_action_pressed("attack") and attacking:
		attack_queued = true
		
func attack_surroundings():
	print("attacking")
	if not $Attack.has_overlapping_bodies(): return
	print("has bodies")
	for body in $Attack.get_overlapping_bodies():
		if body.get("is_enemy"):
			body.die()

func get_animation():
	var requested_animation = "idle-front-right"
	if velocity.length_squared() < 0.01:
		requested_animation = "idle" + get_animation_direction(last_direction)
	else:
		requested_animation = "run" + get_animation_direction(velocity)
		last_direction = velocity

	if requested_animation != current_animation and not attacking and not $AnimationPlayer.is_playing():
		current_animation = requested_animation
		$Sprite.animation = current_animation

func get_animation_direction(dir):
	if dir.x >= 0:
		if dir.y >= 0:
			return "-front-right"
		else:
			return "-back-right"
	else:
		if dir.y >= 0:
			return "-front-left"
		else:
			return "-back-left"

func get_diagonal(dir):
	if dir.x >= 0:
		if dir.y >= 0:
			return Vector2(1, 1)
		else:
			return Vector2(1, -1)
	else:
		if dir.y >= 0:
			return Vector2(-1, 1)
		else:
			return Vector2(-1, -1)

func get_attack_rotation():
	var diagonal = get_diagonal(last_direction)
	return atan2(diagonal.y, diagonal.x) - deg_to_rad(45)

func finished_attack():
	if attack_queued:
		$Sprite.play("attack-heavy" + get_animation_direction(last_direction))
		attack_queued = false
		$Attack.rotation = get_attack_rotation()
	else:
		attacking = false
		$Sprite.play(current_animation)

func freeze_player():
	$Shape.disabled = true
	locked = true
	$Sprite.animation = "idle-front-right"
	
func enter_dungeon():
	$Sprite.modulate = Color(0.80, 0.64, 1.0)
	position.y = -30
	$AnimationPlayer.play("Enter")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Enter":
		locked = false
		$Shape.disabled = false
		
func take_damage(damage):
	print("Hirt for ", damage)


