extends KinematicBody

func _ready():
	pass

func _process(delta):
	move_and_collide(Vector3.FORWARD);
