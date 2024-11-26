extends CharacterBody2D

const SPEED         = 400.0
const JUMP_VELOCITY = -400.0
var direction = -1;

#Bullet Stuff
var cooldown := 1.0
var delay := 0.0
var dir := Vector2(1,0);
var bulletSpeed := 2;
var n_rotation := 0.0;
var bullet := preload("res://scenes/bullet.tscn");
var timer : float = delay;

		
func shoot() -> void:
	var new_bullet : Area2D = bullet.instantiate()
	var player_position = get_parent().get_node("Player").global_position
	var direction_to_player = (player_position - position).normalized()

	get_parent().add_child(new_bullet)
	new_bullet.position = position;
	new_bullet.speed = bulletSpeed
	new_bullet.rotation = direction_to_player.angle()
	new_bullet.dir = direction_to_player

func _physics_process(delta: float) -> void:
	print_debug(position)
	timer += delta;
	if timer >= cooldown:
		shoot();
		timer = 0;
	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = SPEED * direction; 	
	move_and_slide()


func _on_dir_checker_body_entered(_body: Node2D) -> void:
	print_debug("COLLIDE");
	direction *= -1
	velocity.x = SPEED * direction;
