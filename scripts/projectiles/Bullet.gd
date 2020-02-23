extends KinematicBody

var time_scale: float = 1;

const speed: float = 100.0;

func _process(delta):
	delta *= time_scale;
	var collide = move_and_collide(global_transform.basis * Vector3.UP * speed * delta);
	
