extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var number2 = preload("res://assets/img/tile000.png")

"""
170 400
252 400
334 400
416 400
next 
170 482
252 482
334 482
416 482
next 
170 564
252 564
334 564
416 564
next 
170 646
252 646
334 646
416 646

"""

var mx= 170 
var my= 400

onready var default = preload("res://cenas/default.tscn")
onready var peca = preload("res://cenas/pecas.tscn")
# var matrix = [[0,0,0,0],[1,1,1,1],[2,2,2,2],[3,3,3,3]]
var matrix = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

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
			print(x," ",y)
			add_child(s)
			x = x + sobe
		print("next ")
		y = y + sobe
		x = init_x

func add_dois():
		var p = peca.instance()
		p.position.x = mx
		p.position.y = my
		add_child(p)

func getallnodes(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			print("["+N.get_name()+"]")
			getallnodes(N)
		else:
			# Do something
			print("- "+N.get_name())

func _ready():
	#print(matrix[0][0])
	add_default()
	add_dois()
	#add_dois()
	pass


func get_input():
	if Input.is_action_pressed('ui_right'):
		#velocity.x += 1
		var rand_position_x = randi()%3 + 1
		var rand_position_y = randi()%3 + 1
		#print(rand_position_x, " ", rand_position_y)
		#print(matrix[rand_position_x][rand_position_y])
	if Input.is_action_just_pressed('ui_left'):
		#print("esquerdo")
		#velocity.x -= 1
		for i in get_children():
			for j in range(10):
				i.position.x+=int(j)
		
	if Input.is_action_pressed('ui_down'):
		#velocity.y += 1
		pass
	if Input.is_action_pressed('ui_up'):
		pass

func _process(delta):
	get_input()

