extends KinematicBody

const DECAY_RATE = 0.1;

onready var collision = $CollisionShape;

var health: float = 100.0;
var disabled: bool = false;

func _ready():
	pass
	
func damage(amount: float):
	health -= amount;
	# play animation

func _process(delta: float):
	health -= DECAY_RATE;
	if health <= 0:
		queue_free();
