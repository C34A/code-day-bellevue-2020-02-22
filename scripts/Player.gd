extends Spatial

const MOUSE_SENSITIVITY: float = 0.005;
const drop_plane: Plane = Plane(Vector3.UP, 0);
const PAN_SPEED = 300.0
  
onready var camera = $Camera;
onready var towers = get_node("../Towers");

const Base = preload("res://scenes/towers/base/base.tscn");
const Gatling = preload("res://scenes/towers/Gatling.tscn");
const Warp = preload("res://scenes/towers/Warp.tscn");
const Laser = preload("res://scenes/towers/laser/laser.tscn");
const enemy = preload("res://scenes/enemies/NormalEnemy.tscn")

var mouse_down: bool = false;
var placing_tower: bool = false;
var ghost_tower: Spatial;
var can_place_tower: bool = false;
var tower_type: PackedScene;
var placing_tower_4d_offset: int = 0;
var setting_time_scale: bool = false;
var time_scale_set: bool = false;
var time_scale: float = 1;

func _ready():
	get_node("../Control2").pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta: float):
	if setting_time_scale:
		if Input.is_action_just_pressed("edit_scale"):
			time_scale_set = true;
		elif Input.is_action_pressed("place_warp_forwards"):
			time_scale += 0.1;
		elif Input.is_action_pressed("place_warp_back"):
			time_scale -= 0.1;
		time_scale = clamp(time_scale,0.5, 2);
	var place_pressed = false;
	if Input.is_action_just_pressed("ui_cancel"):
		if placing_tower:
			placing_tower = false;
			ghost_tower.queue_free();
	elif Input.is_action_just_pressed("place_tower"):
		placing_tower = !placing_tower;
		if placing_tower:
			placing_tower_4d_offset = 0;
			if Input.is_action_just_pressed("place_gatling"):
				tower_type = Gatling;
			elif Input.is_action_just_pressed("place_laser"):
				tower_type = Laser;
			elif Input.is_action_just_pressed("place_warp"):
				tower_type = Warp;
			ghost_tower = tower_type.instance();
			ghost_tower.ghost = true;
			add_child(ghost_tower);
			ghost_tower.global_transform.basis = Basis();
			ghost_tower.make_ghost();
			ghost_tower.collision_layer = 2;
			ghost_tower.collision_mask = 0;
			_update_ghost_position();
		else:
			ghost_tower.queue_free();
	if placing_tower and not setting_time_scale:
		var time_delta = 0;
		if Input.is_action_pressed("place_warp_back"):
			time_delta = -1;
		elif Input.is_action_pressed("place_warp_forwards"):
			time_delta = 1;
		placing_tower_4d_offset += time_delta;
		placing_tower_4d_offset = clamp(placing_tower_4d_offset, -towers.action_history.size(), 0);
		if placing_tower_4d_offset != 0:
			get_tree().paused = true;
		else:
			get_tree().paused = false;
	
	if placing_tower:
		$Control/TimeBar/Rect.visible = true;
		$Control/TimeBar/Rect.anchor_top = float(placing_tower_4d_offset) / -towers.action_history.size();
	elif not setting_time_scale:
		$Control/TimeBar/Rect.visible = false;
	if setting_time_scale:
		$Control/TimeBar/Rect.anchor_top = 1-(time_scale-0.5)/1.5;
		
	if Input.is_action_just_pressed("ui_cancel"):
		$Control.hide()
		get_node("../Control2").show()
		get_tree().paused = true
		pause_mode = Node.PAUSE_MODE_INHERIT
	if (get_node("../Towers/base")):
		var health = get_node("../Towers/base").health;
		$Control/HealthBar/Rect.anchor_right = health / 100;
	else:
		print("Game over");
	$Control/Money.text = "¥" + str(Econ.money);
#	if Input.is_action_just_pressed("ui_select"):
#		var enem_inst = enemy.instance()
##		get_node("../Enemies").add_child(enem_inst)
##		enem_inst.global_transform = Transform(Basis(), Vector3(10, 0, 10))
#		get_node("../Enemies").spawn_enemy(enem_inst, Vector3(10, 0, 10))

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			mouse_down = event.pressed;
			if placing_tower and can_place_tower and event.pressed:
				var tower2 = tower_type.instance();
				if tower2.get_id() == 3:
					if setting_time_scale:
						tower2.time_scale = time_scale;
						setting_time_scale = false;
					else:
						time_scale = 1.0;
						time_scale_set = false;
						setting_time_scale = true;
						get_tree().paused = true;
						return;
					
				placing_tower = false;
				Econ.money -= ghost_tower.COST;
				ghost_tower.queue_free();
				get_tree().paused = false;
				towers.add_tower(tower2, ghost_tower.global_transform.origin, placing_tower_4d_offset);
		elif event.button_index == 4 && $Camera.transform.origin.x > 1:
			$Camera.transform.origin *= (1/1.1)
		elif event.button_index == 5 && $Camera.transform.origin.x < 30:
			$Camera.transform.origin *= 1.1
	elif event is InputEventMouseMotion:
		if placing_tower and not setting_time_scale:
			_update_ghost_position();
		elif mouse_down and not setting_time_scale:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY);


func _update_ghost_position():
	var position2D = get_viewport().get_mouse_position();
	var position = drop_plane.intersects_ray(
		camera.project_ray_origin(position2D),
		camera.project_ray_normal(position2D));
	ghost_tower.global_transform.origin = position;
	var collision = ghost_tower.move_and_collide(Vector3.ZERO);
	if collision == null and Econ.money >= ghost_tower.COST:
		can_place_tower = true;
		ghost_tower.make_ghost();
	else:
		can_place_tower = false;
		ghost_tower.make_ghost_collision();
	ghost_tower.global_transform.origin = position;


func _on_Button_pressed():
	get_node("../Control2").hide()
	$Control.show()
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_PROCESS
