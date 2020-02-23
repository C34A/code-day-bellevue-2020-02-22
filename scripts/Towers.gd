extends Spatial

const Base = preload("res://scenes/towers/base/base.tscn");
const Gatling = preload("res://scenes/towers/Gatling.tscn");

var towers: Array = [];

func add_tower(tower: Spatial, position: Vector3):
	towers.append(tower);
	tower.global_transform.origin = position;
	add_child(tower);
	
func _ready():
	add_tower(Base.instance(), Vector3.ZERO);
	pass
