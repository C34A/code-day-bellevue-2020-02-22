extends KinematicBody

var time_scale: float = 1;

onready var collision = $CollisionShape;

var health: float = 100.0;
var disabled: bool = false;

func _ready():
	pass
	
func damage(amount: float):
	health -= amount;
	# play animation

func _process(delta: float):
	delta *= time_scale;
	if health <= 0:
		queue_free();

func get_id():
	return 0;
