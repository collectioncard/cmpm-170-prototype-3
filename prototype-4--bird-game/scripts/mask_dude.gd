extends CharacterBody2D


const SPEED = 300.0
const APPROACH_DIST = 500
const JUMP_VELOCITY = -700.0

@export var wander_radius = 100  # how far to wander

@onready var player: CharacterBody2D = get_node('../Player')
@onready var animated_sprite: AnimatedSprite2D = get_node('AnimatedSprite2D')
@onready var start_position: Vector2 = position
@onready var wander_to_right := true


func _ready() -> void:
	animated_sprite.play('run')


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# jump if reach wall
	if is_on_floor() and is_on_wall():
		velocity.y = JUMP_VELOCITY

	if is_on_floor():
		if position.distance_to(player.position) <= APPROACH_DIST:
			approach_player()  # approach player only when close enough
		else:
			wander_around()  # just wander around

	move_and_slide()

	# change animation direction
	animated_sprite.flip_h = velocity.x < 0

	if is_on_floor():
		animated_sprite.play('run')
	else:
		animated_sprite.play('jump')

	# detect kill by bird
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		print(collision.get_collider().name)  # HACK
		if collision.get_collider().name == "bird":
			print("Collision with bird detected.")  # HACK
			# add logic for what happens when colliding with bird


func wander_around():
	if abs(position.x - start_position.x) >= wander_radius:
		wander_to_right = not wander_to_right

	var target_position_x = start_position.x + \
			wander_radius * (1 if wander_to_right else -1)

	velocity.x = SPEED * (1 if target_position_x > position.x else -1)


func approach_player():
	velocity.x = SPEED * (1 if player.position.x > position.x else -1)
