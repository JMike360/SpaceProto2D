extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var gravMass = 100
export var speed = 10
export var rotSpeed = 1.3
export var spawnPos = Vector2(500, 500)
export var f_enabled = true

var anchors = []
var velocity = Vector2(0,0)
var orbitAnchor
var prevPos = Vector2(0,0)
var kf = 0.01
var p = 1.225
var A = 10
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
		
	if(f_enabled):
		#Fd = 0.5 * p * v**2 * k * A
		fnet += -0.5 * p * velocity.length_squared() * kf * A * velocity.normalized()
	return fnet 
	
func setAnchors(_anchors):
	anchors = _anchors
# Called every frame. 'delta' is the elapsed time since the previous frame.

var shouldOrbit = false 
var t = 0
var radius = 50
var orbitSpeed = 1
var boostedOrbitSpeed := 1.0
var bos_increment := 0.04 
var bos_max := 8.0
var bos_min := 1.0
var ems_max = 55
var orbitDir := 1
var entryVel := Vector2(0,0)

func _process(delta):
	t += delta*orbitSpeed
	var boosting = false
	if(Input.is_action_pressed("ui_accept")):
		boosting = true
		
	if(Input.is_action_pressed("ui_left")):
		rotation -= rotSpeed * delta
	elif(Input.is_action_pressed("ui_right")):
		rotation += rotSpeed * delta
	
	$AnimatedSprite.set_animation("firing" if boosting else "default")
	if not boosting and shouldOrbit:
		t = (t - delta*orbitSpeed) + boostedOrbitSpeed*delta	
		position = lerp(position, orbitAnchor.position + Vector2(radius*cos(t*orbitDir), radius*sin(t*orbitDir)), 0.2)
		velocity = (position - prevPos) / (delta*orbitSpeed)
		prevPos = position
		boostedOrbitSpeed = clamp(boostedOrbitSpeed - bos_increment, bos_min, bos_max)
		var pEsc = clamp((orbitAnchor.velocity - velocity).length()/orbitAnchor.escapeVelocity, 0, 1)
		orbitAnchor.get_node("EscapeMeter").scale = Vector2(pEsc * ems_max , pEsc * ems_max)
	elif boosting and shouldOrbit:
		t = (t - delta*orbitSpeed) + boostedOrbitSpeed*delta
		position = lerp(position, orbitAnchor.position + Vector2(radius*cos(t*orbitDir), radius*sin(t*orbitDir)), 0.2)
		velocity = (position - prevPos) / (delta*orbitSpeed)
		prevPos = position		
		boostedOrbitSpeed = clamp(boostedOrbitSpeed + bos_increment, bos_min, bos_max)
		var pEsc = clamp((orbitAnchor.velocity - velocity).length()/orbitAnchor.escapeVelocity, 0, 1)
		orbitAnchor.get_node("EscapeMeter").scale = Vector2(pEsc * ems_max, pEsc * ems_max)
	else:
		var force = calc_net_force(boosting)
		velocity += (force / gravMass) * delta
		position += velocity * delta	

	if orbitAnchor:
		if (orbitAnchor.velocity - velocity).length() > orbitAnchor.escapeVelocity:
			print("Escape velocity exceeded...")
			if $EndOrbitTimer.is_stopped():
				$EndOrbitTimer.start()
	
func calc_t0():
	var vOrbitAnchorToRocket = position - orbitAnchor.position 
	var simpleAngle = atan(abs(vOrbitAnchorToRocket.y) / abs(vOrbitAnchorToRocket.x))
	var angleAdjust = 0
	if(vOrbitAnchorToRocket.x < 0 and vOrbitAnchorToRocket.y >= 0):
		angleAdjust = PI/2
	elif(vOrbitAnchorToRocket.x >= 0 and vOrbitAnchorToRocket.y < 0):
		angleAdjust = -PI/2
	elif(vOrbitAnchorToRocket.x <= 0 and vOrbitAnchorToRocket.y <= 0):
		angleAdjust = PI
	
	return simpleAngle + angleAdjust
	
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			position = spawnPos
			velocity = Vector2(0,0)
			endOrbit()

func _on_Rocket_area_entered(area):
	print("Area entered by: ", area)
	for a in anchors:
		if(a.get_node("OrbitalRange") == area):
			orbitAnchor = a
			entryVel = velocity
			print("Found planet to orbit")
			shouldOrbit = true
			t = calc_t0()
			prevPos = position
			
			var relPos: Vector2 = orbitAnchor.position - position
			var relVel: Vector2 = orbitAnchor.velocity - velocity
			var angle = relPos.angle_to(relVel)

			if angle < 0:
				orbitDir = -1
			else:
				orbitDir = 1



func _on_Rocket_body_entered(body):
	print("Collided with: ", body)
	pass # Replace with function body.

func endOrbit():
	print("ending orbit")
	shouldOrbit = false
	orbitDir = 1
	if(orbitAnchor):
		orbitAnchor.get_node("EscapeMeter").scale = Vector2(1,1)
		orbitAnchor = null

func _on_Rocket_area_exited(area):
	print("Leaving area: ", area)
	endOrbit()
	pass # Replace with function body.

func _on_EndOrbitTimer_timeout():
	print("timeout called...")
	if(orbitAnchor):
		if (orbitAnchor.velocity - velocity).length() > orbitAnchor.escapeVelocity:
			print("ending orbit...")
			endOrbit()
	$EndOrbitTimer.stop()
