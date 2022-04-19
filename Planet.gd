extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var radius = 100
export var speed = 1.0
export var anchor = Vector2(0,0)
export var color = Color(0,0,0)
export var gravMass = 500000000000000

var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	($MeshInstance2D.texture as GradientTexture).gradient.colors[0] = color
	pass # Replace with function body.
	
#func _draw():
#	print("global position:", global_position)
#	print("anchor: ", anchor)
#	draw_arc(anchor - global_position,radius, 0, TAU, 1000, color)
#	print("drawing...")
	
func _physics_process(delta):
	t += delta*speed
	position = Vector2(radius*cos(t), radius*sin(t)) + anchor
	#

func getPosition():
	return position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
