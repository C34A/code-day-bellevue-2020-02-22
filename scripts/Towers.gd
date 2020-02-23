extends Spatial

const Base = preload("res://scenes/towers/Base.tscn");
const Gatling = preload("res://scenes/towers/Gatling.tscn");

onready var enemies = get_node("../Enemies");

var towers: Array = [];

func add_tower(tower: Spatial, position: Vector3):
	towers.append(tower);
	if position != Vector3.ZERO:
		enemies.astar.set_point_disabled(enemies.astar.get_closest_point(Vector2(position.x, position.z)));
	enemies.rebake_curves();
	tower.collision_mask = 3;
	tower.global_transform.origin = position;
	add_child(tower);
	
func _ready():
	add_tower(Gatling.instance(), Vector3.ZERO);
