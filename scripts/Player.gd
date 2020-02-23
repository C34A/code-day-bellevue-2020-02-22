extends Spatial

const MOUSE_SENSITIVITY: float = 0.005;
const drop_plane: Plane = Plane(Vector3.UP, 0);
const PAN_SPEED = 300.0
  
onready var camera = $Camera;
onready var towers = get_node("../Towers");

const Base = preload("res://scenes/towers/base/base.tscn");
const Gatling = preload("res://scenes/towers/Gatling.tscn");
const Laser = preload("res://scenes/towers/laser/laser.tscn");
const Warp = preload("res://scenes/towers/warp/warp.tscn");

var mouse_down: bool = false;
var placing_tower: bool = false;
var ghost_tower: Spatial;
var can_place_tower: bool = false;
var tower_type: PackedScene;

func _ready():
	pass
	
func _process(delta: float):
	var place_pressed = false;
	if Input.is_action_just_pressed("place_tower"):
		placing_tower = !placing_tower;
		if placing_tower:
			if Input.is_action_just_pressed("place_gatling"):
				tower_type = Gatling;
				ghost_tower = Gatling.instance();
			elif Input.is_action_just_pressed("place_laser"):
				tower_type = Laser;
				ghost_tower = Laser.instance();
			elif Input.is_action_just_pressed("place_warp"):
				tower_type = Warp;
				ghost_tower = Warp.instance();
			add_child(ghost_tower);
			ghost_tower.global_transform.basis = Basis();
			ghost_tower.make_ghost();
			ghost_tower.collision_layer = 2;
			ghost_tower.collision_mask = 0;
			_update_ghost_position();
		else:
			ghost_tower.queue_free();

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			mouse_down = event.pressed;
			if placing_tower and can_place_tower and event.pressed:
				placing_tower = false;
				ghost_tower.queue_free();
				towers.add_tower(tower_type.instance(), ghost_tower.global_transform.origin);
		elif event.button_index == 4:
			$Camera.global_transform.origin *= (1/1.1)
		elif event.button_index == 5:
			$Camera.global_transform.origin *= 1.1
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
		can_place_tower = true;
		ghost_tower.make_ghost();
	else:
		can_place_tower = false;
		ghost_tower.make_ghost_collision();
	ghost_tower.global_transform.origin = position;
