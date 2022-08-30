extends Node2D

var ball_layer: Node2D = null

func _process(delta):
	update()

func _draw():
	for child in ball_layer.get_children():
		if not "charge" in child: continue
		if not "lightening" in child: continue
		
		for bolt in child.lightening:
			draw_lightening(bolt[0], bolt[1], bolt[2])

var maxnum = 0

func draw_lightening(start_pos, end_pos, power):
	var per = (power / 1000)
	var width = per * 2
	var color = Color(per, per, 0.8)
	
	if power > maxnum:
		maxnum = power
		print("NEW MAX: " + str(maxnum))

	#if power > 1:
	draw_line(start_pos, end_pos, color, width, true)
