extends CharacterBody2D


const SPEED = 900.0
const ATTACK_SPEED_MUX = 3.0  # X times faster than normal flying speed
const ATTACKING_DURATION = 150  # msec
const ATTACKING_COOLDOWN = 500;
const RANGE = 600  # how far the bird can be away from the player

@onready var anims : AnimatedSprite2D = get_node("AnimatedSprite2D");
@onready var hitbox : Area2D = get_node("attack_area");

var attacking: bool = false
var attack_dir : int = 0;
var attacking_cooldown_time = -1
var attacking_start_time: float = 0.0


func attack_flying():
	anims.play("attacking");
	var direction = Vector2(attack_dir, 1).normalized()
	velocity = direction * SPEED * ATTACK_SPEED_MUX
	
	var bodies : Array[Node2D] = hitbox.get_overlapping_bodies();
	for body in bodies:
		if body.has_method("destroy"):
			body.destroy()
		if body.has_method("shoot"):
			body.queue_free();
	


func normal_flying():
	# read mouse current location
	anims.play("fly");
	var mouse_position = get_global_mouse_position()
	print_debug(mouse_position);

	var player_position = get_parent().global_position + Vector2.UP * 50;
	print_debug(player_position);

	var target_position : Vector2  # where the bird is flying toward

	if player_position.distance_to(mouse_position) > RANGE:
		var heading = (mouse_position - player_position).normalized()
		target_position = player_position + heading * RANGE

	else:
		target_position = mouse_position


	# move the bird
	var direction = (target_position - global_position).normalized()
	if (target_position.distance_to(global_position) < 40):
		velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED

func _process(_delta: float) -> void:
	rotation = abs(velocity.angle())
	anims.flip_v = (rotation) > PI/2;
	
	if (global_position.distance_to(get_parent().global_position) > RANGE * 2):
		position = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if attacking and (Time.get_ticks_msec() - attacking_start_time) > ATTACKING_DURATION:
		attacking = false
	attacking_cooldown_time -= _delta * 1000;
	if attacking:
		attack_flying()
	else:
		normal_flying()

	move_and_slide()


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and attacking_cooldown_time < 0:
			attacking_cooldown_time = ATTACKING_COOLDOWN + ATTACKING_DURATION
			attacking = true
			attack_dir = sign(get_global_mouse_position().x - global_position.x)
			attacking_start_time = Time.get_ticks_msec()


func _on_attack_area_body_entered(body: Node2D) -> void:
	print_debug(body.name)
	if (attacking):
		if body.has_method("destroy"):
			body.destroy()
		if body.has_method("shoot"):
			body.queue_free();
