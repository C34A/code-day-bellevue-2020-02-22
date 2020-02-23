extends Spatial

const MOUSE_SENSITIVITY: float = 0.005;
const drop_plane: Plane = Plane(Vector3.UP, 0);

onready var camera = $Camera;
onready var towers = get_node("../Towers");

var Base = preload("res://scenes/towers/Base.tscn");

var mouse_down: bool = false;
var placing_tower: bool = false;
var ghost_tower: Spatial;

func _ready():
	pass
	
func _process(delta: float):
	if Input.is_action_just_pressed("tower_place"):
		placing_tower = !placing_tower;
		if placing_tower:
			ghost_tower = Base.instance();
			add_child(ghost_tower);
			ghost_tower.disabled = true;
			_update_ghost_position();
		else:
			ghost_tower.queue_free();

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1:
		mouse_down = event.pressed;
		if placing_tower and event.pressed:
			placing_tower = false;
			ghost_tower.queue_free();
			towers.add_tower(Base.instance(), ghost_tower.global_transform.origin);
	elif event is InputEventMouseMotion:
		if placing_tower:
			_update_ghost_position();
		elif mouse_down:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY);


func _update_ghost_position():
	var position2D = get_viewport().get_mouse_position();
	var position = drop_plane.intersects_ray(
		camera.project_ray_origin(position2D),
		camera.project_ray_normal(position2D));
	ghost_tower.global_transform.origin = position;
	var collision = ghost_tower.move_and_collide(Vector3.ZERO);
	if collision == null:
		pass
#		ghost_tower.set_ghost();
	else:
		pass
		# set red ghost
	ghost_tower.global_transform.origin = position;