extends Node2D


onready var timer: Timer = $SwipeTimeout
var swipe_start_position: = Vector2()

export(float, 1.0, 1.5) var max_diagonal_slope: = 1.3

var lista =[1,2,3,4,5]

func _ready():
	lista.pop_front()
	lista.append(7)
	print(lista)

func _start_detection(position: Vector2) -> void:
	swipe_start_position = position
	timer.start()

func _end_detection(position: Vector2) -> void:
	timer.stop()
	var direction: Vector2 = (position - swipe_start_position).normalized()
	print(" ")
	print(direction)

func _input(event):
	if event is InputEventScreenTouch:
		#print(event.position)
		if event.pressed:
			_start_detection(event.position)
		elif not timer.is_stopped():
			_end_detection(event.position)



func _on_SwipeTimeout_timeout():
	pass # Replace with function body.
