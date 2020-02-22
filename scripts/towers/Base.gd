extends StaticBody

onready var collision = $CollisionShape;

var health = 100;

func _ready():
	pass
	
func damage(amount: float):
	health -= amount;
	# play animation

func _process(delta: float):
	if health <= 0:
		pass
