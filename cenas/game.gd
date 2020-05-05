extends Node2D


onready var default = preload("res://assets/number/2.png")

var mx= 170 
var my= 400

var matrix = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

var stack = 0

func mat():
	game()
	stack = 0
	print("\n")
	for i in matrix:
		print(i)


func game():
	randomize()
	var x = randi()%3 + 1
	randomize()
	var y = randi()%3 + 1
	print(x , " ", y)
	if matrix[x][y] == 0:
		matrix[x][y] = 2
		return
	else:
		stack +=1
		if stack >=6:
			print("entrou")
			for i in range(4):
				for j in range(4):
					if matrix[i][j] ==0:
						matrix[i][j]=2
						return
			print("End Game")
		game()

func _ready():
	game()
	game()
	for i in matrix:
		print(i)

func _input(_event):
	if Input.is_action_just_pressed('ui_right'):
		mat()

	
