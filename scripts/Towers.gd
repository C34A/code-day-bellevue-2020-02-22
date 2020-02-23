extends Spatial

const Base = preload("res://scenes/towers/base/base.tscn");
const Gatling = preload("res://scenes/towers/Gatling.tscn");
const Warp = preload("res://scenes/towers/Gatling.tscn");

onready var enemies = get_node("../Enemies");

const TOWER_DECAY_TICKS: int = 60 * 10;

var action_history: Array = [];

func add_tower(tower: Spatial, position: Vector3, temporal_offset: int):
	tower.collision_mask = 3;
	tower.global_transform.origin = position;
	if tower.get_id() != 0:
		tower.lifetime = TOWER_DECAY_TICKS + temporal_offset * 10;
		var closest_point = enemies.astar.get_closest_point(Vector2(position.x, position.z));
		if enemies.astar.get_point_position(closest_point).distance_squared_to(Vector2(position.x, position.z)) < 5:
			enemies.astar.set_point_disabled(closest_point);
			if temporal_offset < 0:
				enemies.warp_forward(-temporal_offset);
			else:
				enemies.rebake_curves();
			
	else:
		add_child(tower);


func _ready():
	add_tower(Base.instance(), Vector3.ZERO, 0);
	pass

var i = 0;

func _process(delta):
	if i % 10 == 0:
		var history_entry = [];
		for t in get_children():
			history_entry.append(Vector3(
				t.global_transform.origin.x,
				t.global_transform.origin.z,
				t.get_id()
			));
		action_history.append(history_entry);
	i += 1;
