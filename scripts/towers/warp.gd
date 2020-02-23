extends KinematicBody


onready var anim = $AnimationPlayer

const GHOST_MATERIAL = preload("res://resources/towers/Gatling/ghost.tres")
const GHOST_COLLISION_MATERIAL = preload("res://resources/towers/Gatling/ghost-collision.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.get_animation("default").set_loop(true)
	anim.play("default")

func set_all_materials(material):
	$Icosphere.set_material_override(material)
	$Cylinder.set_material_override(material)
	$base.set_material_override(material)
	$tower.set_material_override(material)


func make_ghost():
	set_all_materials(GHOST_MATERIAL)


func make_ghost_collision():
	set_all_materials(GHOST_COLLISION_MATERIAL)


func make_not_ghost():
	set_all_materials(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
