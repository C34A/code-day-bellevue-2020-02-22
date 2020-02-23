extends KinematicBody

const COST = 200

const GHOST_MATERIAL = preload("res://resources/towers/Gatling/ghost.tres")
const GHOST_COLLISION_MATERIAL = preload("res://resources/towers/Gatling/ghost-collision.tres")
var disabled: bool = false;
var lifetime: float;
var ghost: bool = false;

onready var anim = $AnimationPlayer
onready var area = $Area;

func _ready():
	anim.get_animation("default").set_loop(true)
	anim.play("default")

func _on_Area_body_entered(body):
	if disabled:
		return;
	if body.get('time_scale') != null:
		body.time_scale = 0.1;
		
func _on_Area_body_exited(body):
	if disabled:
		return;
	if body.get('time_scale') != null:
		body.time_scale = 1;

func _process(delta: float):
	if not ghost:
		lifetime -= 1;
		if lifetime <= 0:
			queue_free();

func set_all_materials(material):
	$Icosphere.set_material_override(material)
	$Cylinder.set_material_override(material)
	$base.set_material_override(material)
	$tower.set_material_override(material)

func make_ghost():
	set_all_materials(GHOST_MATERIAL)
	disabled = true


func make_ghost_collision():
	set_all_materials(GHOST_COLLISION_MATERIAL)


func make_not_ghost():
	set_all_materials(null)
	disabled = false

func get_id():
	return 3;
