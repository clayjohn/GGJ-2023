extends CharacterBody2D

enum WALK {STRAFE, RANDOM}
enum STRAFE_DIR {VERT, HOR}

var player: Node2D
var can_see_player: bool
var last_epoch = 0
@export var direction: Vector2
@export var patrol_pattern: WALK = WALK.STRAFE
@export var patrol_period: float = 3000#ms
@export var strafe_dir = STRAFE_DIR.VERT
@export var speed = 45

func rand_unit():
	return Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_player()
	last_epoch = Time.get_ticks_msec()
	randomize()
	$AnimatedSprite2D.play("Idle")

func follow_player(dt):
	direction = (player.transform.origin - transform.origin).normalized()

func walk_strafe(dt):
	if Time.get_ticks_msec() - last_epoch > patrol_period:
		if strafe_dir == STRAFE_DIR.VERT:
			if direction.x > 0.01 or direction.x < -0.01:
				direction = Vector2(0, -1)
			direction.y = -direction.y
		else:
			if direction.y > 0.01 or direction.y < -0.01:
				direction = Vector2(1, 0)
			direction.x = -direction.x
		last_epoch = Time.get_ticks_msec()
	
func walk_random(dt):
	if Time.get_ticks_msec() - last_epoch > patrol_period:
		direction = rand_unit()
		last_epoch = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_see_player:
		follow_player(delta)
	elif patrol_pattern == WALK.STRAFE:
		walk_strafe(delta)
	elif patrol_pattern == WALK.RANDOM:
		walk_random(delta)

	set_velocity(direction * speed)
	var collision = move_and_collide(velocity * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())

func _on_vision_body_entered(body):
	if body == player:
		can_see_player = true

func _on_vision_body_exited(body):
	pass


func _on_attack_range_body_entered(body):
	if body == player:
		$AnimatedSprite2D.animation = "Attack"

func _on_attack_range_body_exited(body):
	if body == player:
		$AnimatedSprite2D.animation = "Idle"


func _on_long_site_body_entered(body):
	pass

func _on_long_site_body_exited(body):
	if body == player:
		can_see_player = false
