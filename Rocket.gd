extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var gravMass = 100
export var speed = 10
export var rotSpeed = 1
var anchors = []
var velocity = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# F = G * (m1 * m2 ) / r**2
# G = 6.67430 * 10**(-11) N m^2 / kg^2
var G = 6.67430 * pow(10, -11)
func calc_net_force(var boosting):
	var fnet = Vector2(0,0) if not boosting else speed * Vector2(sin(rotation), -cos(rotation))
	#print("Boosted vector: ", speed * Vector2(cos(rotation), sin(rotation)))
	# print("anchors: ", anchors)
	for planet in anchors:
		var rsq = position.distance_squared_to(planet.position)
		var fmag = G * (planet.gravMass * gravMass) /  rsq
		fnet += fmag * position.direction_to(planet.position)
	# print(fnet)
		
	return fnet 
	
func setAnchors(_anchors):
	anchors = _anchors
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var boosting = false
	if(Input.is_action_pressed("ui_accept")):
		boosting = true
		
	if(Input.is_action_pressed("ui_left")):
		rotation -= rotSpeed * delta
	elif(Input.is_action_pressed("ui_right")):
		rotation += rotSpeed * delta
	
	$AnimatedSprite.set_animation("firing" if boosting else "default")
	
	var force = calc_net_force(boosting)
	velocity += (force / gravMass) * delta
	position += velocity * delta
	
	
	
