extends Spatial

var time_scale: float = 1;

var spawn_bullets: bool = false
var target_point: Vector2 = Vector2(0, 1)
const COOLDOWN: float = 0.25
var shot_cooldown: float = 0.25
var disabled: bool = false
var ghost: bool = false;
var lifetime: float;

const COST = 100

const RANGE = 100.0

onready var animation = $AnimationPlayer
onready var turret_top = $tower/top
onready var bullet_point = $tower/top/bullet_point

const ROTSPEED: float = .75
var slerp_val: float = 0.0

const GHOST_MATERIAL = preload("res://resources/towers/Gatling/ghost.tres")
const GHOST_COLLISION_MATERIAL = preload("res://resources/towers/Gatling/ghost-collision.tres")

const bullet_scene = preload("res://scenes/projectiles/Bullet.tscn")

func _ready():
	$AnimationPlayer.get_animation("default").set_loop(true)
#	start_shooting();

func _process(delta):
	delta *= time_scale;
	if not ghost:
		lifetime -= time_scale;
		if lifetime <= 0:
			queue_free();
	animation.playback_speed = time_scale;
	if not disabled:
		var pos: Vector2 = Vector2(global_transform.origin.x, global_transform.origin.z)
#		var target_angle float = atan2((target_point - pos).x, (target_point - pos).y)
		
		var targ: Vector3 = Vector3(target_point.x, 0, target_point.y);
		var rotTransform = global_transform.looking_at(targ, Vector3.UP).rotated(Vector3.UP, PI)
		var thisRotation = Quat(global_transform.basis).slerp(rotTransform.basis, slerp_val)
		slerp_val += ROTSPEED * delta
		if slerp_val > 1:
			slerp_val = 1
		turret_top.set_global_transform(Transform(thisRotation, turret_top.global_transform.origin))

		
		if spawn_bullets:
			if shot_cooldown <= 0:
				var projectile = bullet_scene.instance()
				get_node("../..").add_child(projectile)
				projectile.global_transform = bullet_point.global_transform
#				projectile.global_rotate(Vector3.UP, bullet_point.global_transform.basis.get_euler().y)

				shot_cooldown = COOLDOWN
			else:
				shot_cooldown -= delta


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
	#rotate barrels
	animation.play("default")


func set_all_materials(material):
	$tower.set_material_override(material)
	$tower/top.set_material_override(material)
	$tower/top/barrels.set_material_override(material)
	$tower/top/base.set_material_override(material)

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
	$tower.set_material_override(1, load("res://resources/towers/base/base.material"))
	disabled = false


func stop_shooting():
	spawn_bullets = false
	animation.stop()

func get_id():
	return 1;
