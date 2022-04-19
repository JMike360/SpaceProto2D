extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var anchorNode
var sunNode
var t = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	sunNode = get_node("../Rocket")
	anchorNode = sunNode

func set_anchor_node(node):
	anchorNode = node
# Called every frame. 'delta' is the elapsed time since the previous frame.

func setRotation():
	var vector_to_sun = sunNode.global_position - position
	rotation = 0
	
	
func _process(delta):
	position = anchorNode.global_position
	#look_at(sunNode.anchor)
