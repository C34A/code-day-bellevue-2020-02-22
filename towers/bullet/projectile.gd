extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(Vector3.FORWARD, Vector3.UP)
