extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var anchors
func _draw():
	for anchor in anchors:
		draw_arc(anchor.anchor, anchor.radius, 0, TAU, 1000, anchor.color)
	draw_line(anchors[0].anchor, anchors[0].anchor + Vector2(0, -30), anchors[0].color)


func _ready():
	anchors = [$Sun, $Planet, $Planet2, $Planet3]
	#update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
