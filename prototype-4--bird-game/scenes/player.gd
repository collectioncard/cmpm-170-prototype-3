extends CharacterBody2D


const SPEED = 1400.0
const JUMP_VELOCITY = -1400.0

@onready var cur_bird : CharacterBody2D = get_node("%AttackBird");

func _process(_delta: float) -> void:
	if position.y > 1500:
		position = Vector2(-2535, 130);

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		if (cur_bird.position.length() < 200):	
			velocity.y = JUMP_VELOCITY - 240
		else:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
