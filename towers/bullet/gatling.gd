extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawn_bullets: bool = false
var target_point: Vector3 = Vector3(0, 0, 1)

const ROTSPEED: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.get_animation("default").set_loop(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("TEST-shoot"):
		start_shooting()
	elif Input.is_action_just_pressed("TEST-stopshoot"):
		stop_shooting()
	
	var target_angle: float = global_transform.origin.angle_to(target_point)
	print($tower/top.global_transform.basis.get_euler().y - target_angle)
	
#	$tower/top.global_transform.basis = $tower/top.global_transform.basis.rotated(Vector3.UP, ROTSPEED * delta)
	$tower/top.rotate_y(ROTSPEED * delta * sign(target_angle - $tower/top.global_transform.basis.get_euler().y))

func start_shooting():
	spawn_bullets = true
	#rotate barrels
	$AnimationPlayer.play("default")
	
func stop_shooting():
	spawn_bullets = false
	$AnimationPlayer.stop()
