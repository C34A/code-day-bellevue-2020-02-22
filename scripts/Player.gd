extends Spatial

const MOUSE_SENSITIVITY = 0.005;
const drop_plane = Plane(Vector3.UP, 0);

onready var camera = $Camera;
onready var ghost_tower = $GhostTower;
onready var towers = get_node("../Towers");

var Base = preload("res://scenes/towers/Base.tscn");

var mouse_down = false;
var placing_tower = false;

func _ready():
	pass
	
func _process(delta: float):
	if Input.is_action_just_pressed("tower_place"):
		placing_tower = !placing_tower;
		ghost_tower.visible = placing_tower;
		if placing_tower:
			_update_ghost_position();

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1:
		mouse_down = event.pressed;
		if placing_tower and event.pressed:
			placing_tower = false;
			ghost_tower.visible = false;
			towers.add_tower(Base.instance(), ghost_tower.translation);
	elif event is InputEventMouseMotion:
		if placing_tower:
			_update_ghost_position();
		elif mouse_down:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY);


func _update_ghost_position():
	var position2D = get_viewport().get_mouse_position();
	ghost_tower.global_transform.origin = drop_plane.intersects_ray(
		camera.project_ray_origin(position2D),
		camera.project_ray_normal(position2D));
