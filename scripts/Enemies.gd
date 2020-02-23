extends Spatial

var NormalEnemy = preload("res://scenes/enemies/NormalEnemy.tscn");

var enemies: Array = [];
var astar: AStar2D;
const RESOLUTION = 4;
const SIZE = 40;

func spawn_enemy(enemy: Spatial, position: Vector3):
	enemies.append(enemy);
	enemy.global_transform.origin = position;
	add_child(enemy);
	
func rebake_curves():
	for e in enemies:
		e.curve = null;
	
func _ready():
	astar = AStar2D.new();
	var i = 0;
	var middle;
	for x in range(-SIZE/RESOLUTION, SIZE/RESOLUTION):
		for y in range(-SIZE/RESOLUTION, SIZE/RESOLUTION):
			astar.add_point(i, Vector2(x * RESOLUTION,  y * RESOLUTION));
			if x == 0 && y == 0:
				middle = i;
			if i > 0:
				astar.connect_points(i, i - 1);
			if i - SIZE/RESOLUTION*2 >= 0:
				astar.connect_points(i, i - SIZE/RESOLUTION*2);
			i += 1;
#	for p in astar.get_points():
#		var p2 = astar.get_point_position(p);
#		print(p2)
#		var s = CSGSphere.new();
#		s.radius = 0.3;
#		s.global_translate(Vector3(p2.x, 0, p2.y));
#		.add_child(s);
	var enemy = NormalEnemy.instance();
	enemy.astar = astar;
	enemy.target_point = middle;
	spawn_enemy(enemy, Vector3(0, 0, 100));
