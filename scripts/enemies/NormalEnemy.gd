extends KinematicBody

const SPEED = 1.0

func _ready():
	pass

func _process(delta):
	move_and_collide(Vector3.FORWARD * delta * SPEED);
