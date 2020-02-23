extends KinematicBody

var time_scale: float = 1;
var timer
var override_pos
var health: int = 10
var particles = preload("res://scenes/enemies/Particles.tscn")
var action_history: Array = [];
var speed: float = 10;
var astar: AStar2D;
#var spheres = [];
var curve: Curve2D;
var target_point: int;
var i: int = 0;
var slerp_val: float

const ATTACK_COOLDOWN = 1.0
var cooldown = 1.0
const DAMAGE = 25.1 #.1 in case of float error

func _ready():
	pass


func hit(damage: int):
	health -= damage;
	if health <= 0:
		Econ.money += Econ.KILL_REWARD;
#		queue_free()
		var transform = global_transform
		var particles_inst = particles.instance()
		get_node("../..").add_child(particles_inst)
		particles_inst.global_transform = transform
		queue_free()
#		get_parent().
var history_tick = 0;

func _process(delta):
	delta *= time_scale;
	var position2D = Vector2(translation.x, translation.z);
	var point = astar.get_closest_point(position2D);
	var path = astar.get_point_path(point, target_point);
	if (path.size() < 2):
		return;
#	for s in spheres:
#		s.queue_free();
#	spheres = []
	if !curve:
		i = 0;
		curve = Curve2D.new();
		curve.add_point(path[0]);
		for i in range(1, path.size()-1):
			var p = path[i];
			var control = get_control_points(path[i-1], path[i], path[i+1], 0.5);
			curve.add_point(path[i], control[0]-p, control[1]-p);
		curve.add_point(path[-1]);
		
		curve.bake_interval = 1
		
#	for p2 in curve.get_baked_points():
#		var s = CSGSphere.new();
#		s.radius = 0.1;
#		s.global_translate(Vector3(p2.x, 0, p2.y));
#		get_parent().add_child(s);
#		spheres.append(s);
#
		
	var start_deg = rotation;
	if curve.get_baked_points()[i].distance_squared_to(Vector2(transform.origin.x, transform.origin.z)) < 0.5 * 0.5:
		i += 1;
		slerp_val = 0.0;
	var target = Vector3(curve.get_baked_points()[i].x, 0, curve.get_baked_points()[i].y);
	var toNext = transform.looking_at(target, Vector3.UP)
	var thisRot = Quat(transform.basis).slerp(toNext.basis.get_rotation_quat(), slerp_val)
	slerp_val += 2.0 * delta
	if slerp_val > 1:
		slerp_val = 1;
	
	set_transform(Transform(thisRot, transform.origin))
	
	var rot_dist = rotation - start_deg;
	
	rotate_x(rot_dist.y)
	
	var collision = move_and_collide((target - transform.origin).normalized() * delta * speed);
	if collision != null:
#		print("bink")
		if collision.collider.get_name() == "base":
#			print("bank")
			if cooldown <= 0:
#				print("bonk")
				collision.collider.damage(DAMAGE)
				cooldown = ATTACK_COOLDOWN
	cooldown -= delta
	if history_tick % 10 == 0:
		action_history.append(position2D);
	history_tick += 1;

func warp_forward(offset):
	var original_point = transform.origin;
	transform.origin = Vector3(action_history[-offset].x, 0, action_history[-offset].y);
	var distance_set_back = transform.origin.distance_to(original_point);
	
	var point = astar.get_closest_point(action_history[-offset]);
	var path = astar.get_point_path(point, target_point);
	if (path.size() < 2):
		return;
	curve = Curve2D.new();
	curve.add_point(path[0]);
	for i in range(1, path.size() - 1):
		var p = path[i];
		var control = get_control_points(path[i-1], path[i], path[i+1], 0.5);
		curve.add_point(path[i], control[0]-p, control[1]-p);
	curve.add_point(path[-1]);
	curve.bake_interval = 1
	
	i = int(curve.get_baked_points().size() * distance_set_back / curve.get_baked_length());
	transform.origin = Vector3(
		curve.interpolate_baked(distance_set_back).x, 0,
		curve.interpolate_baked(distance_set_back).y);
	transform = transform.looking_at(Vector3.ZERO, Vector3.UP);

func get_control_points(p0, p1, p2, t):
	var d01 = sqrt(pow(p1.x - p0.x, 2) + pow(p1.y - p0.y, 2));
	var d12 = sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
   
	var fa = t * d01 / (d01 + d12);
	var fb = t - fa;
  
	var p1x = p1.x + fa * (p0.x - p2.x);
	var p1y = p1.y + fa * (p0.y - p2.y);

	var p2x = p1.x - fb * (p0.x - p2.x);
	var p2y = p1.y - fb * (p0.y - p2.y);
	
	return [Vector2(p1x, p1y), Vector2(p2x, p2y)];
