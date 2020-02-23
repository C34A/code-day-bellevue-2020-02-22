extends KinematicBody

var time_scale: float = 1;
const DECAY_RATE = 0.1;

onready var collision = $CollisionShape;

var health: float = 100.0;
var disabled: bool = false;

func _ready():
	pass
	
func damage(amount: float):
	health -= amount;
	# play animation
	$Particles.emitting = true

func _process(delta: float):
	delta *= time_scale;
	health -= DECAY_RATE * delta;
	if health <= 0:
		queue_free();
