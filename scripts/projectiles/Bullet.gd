extends KinematicBody


const speed: float = 20.0;

func _process(delta):
	move_and_collide(global_transform.basis * Vector3.UP * speed * delta);
