extends Area2D

@export var speed: float = 200;
@export var dir: Vector2 = Vector2.ZERO;

var lifespan: float = 5;

@onready var player = get_parent().get_node("Player")


func _process(_delta) -> void:
	self.position += speed * dir;
	#print_debug("Speed:" +str(speed) + " Dir:" + str(dir))
	lifespan -= _delta;
	if lifespan <= 0:
		queue_free();


func _on_body_entered(body : Node2D):
	if body == player:
		get_tree().reload_current_scene()
	else:
		call_deferred("queue_free");
