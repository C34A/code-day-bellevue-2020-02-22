extends Particles


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var elapsed_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	if elapsed_time >= lifetime:
		queue_free()
