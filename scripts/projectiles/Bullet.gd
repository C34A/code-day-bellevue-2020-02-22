extends KinematicBody

var time_scale: float = 1;
var timer: float = 0.0
const LIFETIME: float = 10.0
const speed: float = 500.0;
var particles = preload("res://scenes/Particles-hit.tscn")

func _ready():
	pass

func _process(delta):
	timer += delta
	if timer > LIFETIME:
		queue_free()
	delta *= time_scale;
	var collide = move_and_collide(global_transform.basis * Vector3.UP * speed * delta);
	if collide != null:
		collide.collider.hit(1)
		var transform = global_transform
		var particles_inst = particles.instance()
		get_node("../../..").add_child(particles_inst)
		particles_inst.global_transform = transform
		queue_free()
	
