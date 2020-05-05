extends Node2D

onready var default = preload("res://cenas/default.tscn")

func add_default():
	var init_x = 170
	var x = init_x
	var y = 400
	var sobe = 82
	for _j in range(4):
		for _i in range(4):
			var s = default.instance()
			s.position.x = x
			s.position.y = y
			add_child(s)
			x = x + sobe
		y = y + sobe
		x = init_x

func _ready():
	add_default()
