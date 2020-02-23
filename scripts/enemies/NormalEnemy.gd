extends KinematicBody

var speed = 10;
var astar: AStar2D;
#var spheres = [];
var curve;
var target_point;
var i = 0;

func _ready():
	pass
	
func _process(delta):
	var point = astar.get_closest_point(Vector2(translation.x, translation.z));
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
		
		
	if curve.get_baked_points()[i].distance_squared_to(Vector2(transform.origin.x, transform.origin.z)) < 0.5 * 0.5:
		i += 1;
	var target = Vector3(curve.get_baked_points()[i].x, 0, curve.get_baked_points()[i].y);
	transform = transform.looking_at(target, Vector3.UP)
	move_and_collide((target - transform.origin).normalized() * delta * speed);

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
