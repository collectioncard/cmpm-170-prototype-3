extends CharacterBody2D


const SPEED = 300.0
const ATTACK_SPEED_MUX = 3.0  # X times faster than normal flying speed
const ATTACKING_DURATION = 150  # msec
const RANGE = 100  # how far the bird can be away from the player


var attacking: bool = false
var attacking_start_time: float = 0.0

func attack_flying():
	var direction = Vector2(1, 1).normalized()
	velocity = direction * SPEED * ATTACK_SPEED_MUX


func normal_flying():
	# read mouse current location
	var mouse_position = get_global_mouse_position()

	var player_position = Vector2(100, 100)  # HACK


	var target_position  # where the bird is flying toward

	if player_position.distance_to(mouse_position) > RANGE:
		var heading = (mouse_position - player_position).normalized()
		target_position = player_position + heading * RANGE

	else:
		target_position = mouse_position


	# move the bird
	var direction = (target_position - global_position).normalized()
	velocity = direction * SPEED


func _physics_process(_delta: float) -> void:
	if (Time.get_ticks_msec() - attacking_start_time) > ATTACKING_DURATION:
		attacking = false

	if attacking:
		attack_flying()
	else:
		normal_flying()

	print(velocity)  # HACK
	move_and_slide()


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			attacking = true
			attacking_start_time = Time.get_ticks_msec()
