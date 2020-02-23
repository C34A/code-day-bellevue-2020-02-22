extends Spatial

var time_scale: float = 1;

var spawn_bullets: bool = false
var target_point: Vector2 = Vector2(0, 1)
const COOLDOWN: float = .75
var shot_cooldown: float = 0.75
var disabled: bool = false
var ghost: bool = false;
var lifetime: float;
var cast_yet: bool = false;

var poof = preload("res://scenes/Particles_poof.tscn")

const COST = 150

const RANGE = 1000.0

onready var animation = $AnimationPlayer
onready var turret_top = $top
onready var raycast = $top/RayCast;

const ROTSPEED: float = .75
var slerp_val = 0

const GHOST_MATERIAL = preload("res://resources/towers/Gatling/ghost.tres")
const GHOST_COLLISION_MATERIAL = preload("res://resources/towers/Gatling/ghost-collision.tres")

func _ready():
	animation.set_speed_scale(0.5)

func _process(delta):
	delta *= time_scale;
	if not ghost:
		lifetime -= time_scale;
		if lifetime <= 0:
#			var poof_inst = poof.instance()
#			var t = global_transform
#			get_parent().add_child(poof_inst)
#			poof_inst.emitting = true
#			poof_inst.global_transform = t
			queue_free();
	if not disabled:
		var pos: Vector2 = Vector2(global_transform.origin.x, global_transform.origin.z)
#		var target_angle: float = atan2((target_point - pos).x, (target_point - pos).y)
##		print($tower/top.global_transform.basis.get_euler().y - target_angle)
#		print(target_point)
#		print(target_angle)
		
	#	$tower/top.global_transform.basis = $tower/top.global_transform.basis.rotated(Vector3.UP, ROTSPEED * delta)
#		var turret_rot = (turret_top.global_transform.basis.get_euler().y)
		
#		while(target_angle > (2*PI)):
#			target_angle -= 2*PI
#		while(target_angle < 0):
#			target_angle += 2*PI
#
#		while(turret_rot > (2*PI)):
#			turret_rot -= 2*PI
#		while(turret_rot < 0):
#			turret_rot += 2*PI
#
#		print(turret_rot, " ", target_angle)
#		turret_top.rotate_y(ROTSPEED * delta * sign((target_angle - PI/2) - turret_rot))
		
		var targ: Vector3 = Vector3(target_point.x, 0, target_point.y);
		var rotTransform = global_transform.looking_at(targ, Vector3.UP).rotated(Vector3.UP, PI/2.0)
		var thisRotation = Quat(global_transform.basis).slerp(rotTransform.basis, slerp_val)
		slerp_val += ROTSPEED * delta
		if slerp_val > 1:
			slerp_val = 1
		turret_top.set_global_transform(Transform(thisRotation, turret_top.global_transform.origin))
		
		if spawn_bullets:
			if shot_cooldown <= 0:
				$AnimationPlayer.play("default")
				shot_cooldown = COOLDOWN
				cast_yet = false;
			else:
				shot_cooldown -= delta
			if shot_cooldown < 0.7 and not cast_yet:
				cast_yet = true;
				var collider = raycast.get_collider();
				if collider:
					collider.hit(3);


func _physics_process(delta):
	
	var targetEnemy
	var targetEnemyDist = 9999999.0
	for e in get_node("../../Enemies").get_children():
		var dist = global_transform.origin.distance_squared_to(e.global_transform.origin)
		if dist < targetEnemyDist:
			targetEnemyDist = dist
			targetEnemy = e
	
	if targetEnemyDist < RANGE:
		disabled = false
		if not is_ghost():
			start_shooting()
			point_towards(targetEnemy)
	else:
		stop_shooting()
		disabled = true

func point_towards(target: Spatial):
	target_point = Vector2(target.global_transform.origin.x, target.global_transform.origin.z)


func start_shooting():
	spawn_bullets = true


func set_all_materials(material):
	$tower.set_material_override(material)
	$top.set_material_override(material)
	$top/base.set_material_override(material)
	$top/Cylinder.set_material_override(material)
	$top/Cylinder001.set_material_override(material)

func is_ghost() -> bool:
	if turret_top.material_override == null:
		return false
	else:
		return true

func make_ghost():
	stop_shooting()
	set_all_materials(GHOST_MATERIAL)
	disabled = true


func make_ghost_collision():
	set_all_materials(GHOST_COLLISION_MATERIAL)


func make_not_ghost():
	stop_shooting()
	set_all_materials(null)
	disabled = false


func stop_shooting():
	spawn_bullets = false

func get_id():
	return 2;
