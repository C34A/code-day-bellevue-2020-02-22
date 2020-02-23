extends KinematicBody


const speed: float = 100.0;

func _process(delta):
	var collide = move_and_collide(global_transform.basis * Vector3.UP * speed * delta);
	
