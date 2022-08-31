extends Node2D

func _ready():
	randomize()
	$LighteningLayer.ball_layer = $BallLayer

var mouse_left_down := false
var mouse_position := Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
			mouse_position = self.get_local_mouse_position()
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
			mouse_position = self.get_local_mouse_position()

	if event is InputEventMouseMotion:
		mouse_position = self.get_local_mouse_position()
	
func _on_SpawnBallTimer_timeout():
	if not mouse_left_down: return
	
	if mouse_position.x < 10 or mouse_position.x > 990: return
	if mouse_position.y < 10 or mouse_position.y > 590: return
	
	var newball = load("res://Components/EnergyBall/EnergyBall.tscn").instance()
	newball.position = mouse_position
	
	if newball.position.y < 200:
		newball.charge = 1000
	elif newball.position.y > 290:
		newball.charge = -1000
	else:
		newball.charge = rand_range(-5, 5)
	
	$BallLayer.add_child(newball)


func _on_CleanupTimer_timeout():
	
	for child in $BallLayer.get_children():
		if not "charge" in child: continue
		
		if child.charge < -200 or child.charge > 200: continue
		if child.speed > 0: continue
	
		$BallLayer.remove_child(child)
		child.queue_free()
