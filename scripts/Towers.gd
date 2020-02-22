extends Spatial

var Base = preload("res://scenes/towers/Base.tscn");

var towers: Array = [];

func add_tower(tower: Node, position: Vector3):
	towers.append(tower);
	tower.global_transform.origin = position;
	add_child(tower);
	
func _ready():
	add_tower(Base.instance(), Vector3.ZERO);
	pass
