extends KinematicBody2D

export var charge := 0.0

var current_color = Color.white
var lightening = []
var velocity := Vector2.ZERO
var time_next_switch = 0
var speed := 15.0
var scale_direction := 0
var scale_speed := 0.0
var lightening_rod := Vector2.ZERO

const min_scale_speed := 0.1
const max_scale_speed := 0.5

func _ready():
	randomize()
	
	if randf() > 0.5:
		velocity *= -1

	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	
	if randf() > 0.3:
		var cp = charge / 1000
		
		velocity.y = cp
	
	rotate(rand_range(-0.3, 0.3))
	
	speed = rand_range(2, 12)

	scale_direction = 1
	if randf() > 0.5:
		scale_direction = -1

	scale_speed = rand_range(min_scale_speed, max_scale_speed)
	
	lightening_rod = Vector2(rand_range(-10, 10), rand_range(-10, 10))

	update_color()

func _process(delta):
	if speed > 0:
		position += velocity * delta * speed
		speed -= delta
	
	if OS.get_system_time_msecs() >= time_next_switch:
		lightening_rod = Vector2(rand_range(-10, 10), rand_range(-10, 10))
		time_next_switch = OS.get_system_time_msecs() + rand_range(100, 3000)
	
	scale += (scale_speed * scale_direction * Vector2.ONE * delta)
	
	if scale.x > 1.5:
		scale_direction *= -1
		scale_speed = rand_range(min_scale_speed, max_scale_speed)
		scale.x = 1.49
	elif scale.x < 0.5:
		scale_direction *= -1
		scale_speed = rand_range(min_scale_speed, max_scale_speed)
		scale.x = 0.51

	lightening.clear()
	for ball in get_parent().get_children():
		if ball == self: continue
		if not "charge" in ball: continue
		
		var charge_diff = self.charge - ball.charge
		
		if charge_diff == 0: continue
		
		var distance = self.position.distance_to(ball.position)
		
		var max_distance = 140 * scale.x
		
		if distance > max_distance: continue
		
		var max_throughput = (distance / max_distance) * charge_diff
		
		var transfer_amount = max_throughput
		
		if transfer_amount < 0: continue
		
		if sqrt(distance * 4) > charge_diff: continue
		
		ball.charge += transfer_amount
		charge -= transfer_amount
		
		if transfer_amount > 200:
			lightening.append([self.position + self.lightening_rod, ball.position + ball.lightening_rod, transfer_amount])
		
	update_color()
		
func update_color():
	var charge_percent = abs(charge / 1000)
	var color_scale = (charge_percent * 0.80) + 0.1
	var secondary_color_scale = 0.1 - (charge_percent * 0.1)
	if charge > 0:
		# + charge, so scale from (0.2,0.2,0.2) to (1, 0, 0)
		current_color = Color(color_scale, secondary_color_scale, secondary_color_scale, 0.3)
	elif charge < 0:
		# - charge, so scale from (0.2,0.2,0.2) to (0, 0, 1)
		current_color = Color(secondary_color_scale, secondary_color_scale, color_scale, 0.3)
	else:
		current_color = Color(0.1, 0.1, 0.1, 0.3)
	update()

func _draw():
	var cc1 = Color(current_color.r, current_color.g, current_color.b, 0.05)
	draw_circle(Vector2(8, 12), 20, cc1)
	draw_circle(Vector2(-12, -13), 20, cc1)
	draw_circle(Vector2(0, -6), 20, cc1)
	var cc2 = Color(current_color.r, current_color.g, current_color.b, 0.03)
	draw_circle(Vector2(-3, 2), 50, cc2)
	draw_circle(Vector2(3, -2), 50, cc2)
	draw_circle(Vector2(3, 2), 50, cc2)
	var cc3 = Color(current_color.r, current_color.g, current_color.b, 0.01)
	draw_circle(Vector2.ZERO, 100, cc3)
