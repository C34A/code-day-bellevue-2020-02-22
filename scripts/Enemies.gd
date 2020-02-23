extends Spatial

var NormalEnemy = preload("res://scenes/enemies/NormalEnemy.tscn");

var enemies: Array = [];

func spawn_enemy(enemy: Spatial, position: Vector3):
	enemies.append(enemy);
	enemy.global_transform.origin = position;
	add_child(enemy);
	
func _ready():
	spawn_enemy(NormalEnemy.instance(), Vector3.LEFT * 10);
	pass
