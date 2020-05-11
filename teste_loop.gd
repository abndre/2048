extends Node2D

#var matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]

var matrix =[[1,2],[0,0],[3,3]]

func _ready():
	#print(len(matrix))
	randomize()
	var rand = randi()%len(matrix)
	print(rand)
	print(matrix[rand])
	# randi()%3 + 1
