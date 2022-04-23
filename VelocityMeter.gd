extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rocket
# Called when the node enters the scene tree for the first time.
func _ready():
	rocket = get_node("../../Rocket")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Velocity: " + str(round(rocket.velocity.length())) + " m/s"
