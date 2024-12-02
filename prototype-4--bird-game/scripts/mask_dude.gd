class_name MaskDude extends CharacterBody2D


const SPEED = 300.0
const APPROACH_DIST = 500
const JUMP_VELOCITY = -800.0

@export var wander_radius = 100  # how far to wander

@onready var player: CharacterBody2D = get_node('../Player')
@onready var animated_sprite: AnimatedSprite2D = get_node('AnimatedSprite2D')
@onready var despawn_timer: Timer = get_node('despawn_timer')
@onready var start_position: Vector2 = position
@onready var wander_to_right := true
@onready var is_dead := false


func _ready() -> void:
	animated_sprite.play('run')


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# jump if reach wall
	if is_on_floor() and is_on_wall():
		velocity.y = JUMP_VELOCITY

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


func wander_around():
	if abs(position.x - start_position.x) >= wander_radius:
		wander_to_right = not wander_to_right

	var target_position_x = start_position.x + \
			wander_radius * (1 if wander_to_right else -1)

	velocity.x = SPEED * (1 if target_position_x > position.x else -1)


func approach_player():
	velocity.x = SPEED * (1 if player.position.x > position.x else -1)


func destroy():
	is_dead = true
	animated_sprite.play('hit')

	despawn_timer.start()  # start the timer



func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()
