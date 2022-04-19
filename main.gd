extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var screen_size
var index = 0

var camera_anchor
var anchors


	
	
func _ready():
	screen_size = get_viewport().size
	anchors = $SolarSystem.anchors
	$Rocket.setAnchors(anchors)
	#update()



func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		index = (index + 1)%len(anchors)
		camera_anchor = anchors[index]

		$MainCamera.set_anchor_node(camera_anchor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
