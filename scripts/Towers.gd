extends Spatial

var Base = preload("res://scenes/towers/Base.tscn");

var towers = [];

func add_tower(tower: Node, position: Vector3):
	towers.append(tower);
	tower.translate(position);
	add_child(tower);
	
func _ready():
	add_tower(Base.instance(), Vector3.ZERO);
	pass
