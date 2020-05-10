extends Node2D


var width := 4
var height :=4

var x := 160
var y := 400
var plus := 82

onready var default = preload("res://cenas/default.tscn")
onready var twopiece = preload("res://pieces/2piece.tscn")

var board = [[null,null,null,null],[null,null,null,null],[null,null,null,null],[null,null,null,null]]	
var pos_matrix =  [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

func grid_to_pixel(grid: Vector2):
		return Vector2(x + grid.x*plus, y + grid.y*plus)

func update_piece(piece, i, j):
	var n_piece = piece.next_piece.instance()
	add_child(n_piece)
	n_piece.position = grid_to_pixel(Vector2(i,j))
	board[i][j] = n_piece

func update_one_piece(piece, i, j, plus):
	piece.move(grid_to_pixel(Vector2(i+plus, j)))
	board[i][j] =null
	board[i+plus][j] =piece

func update_two_pieces(piece_one, piece_two, i, j , plus):
	# move a peca
	piece_one.move(grid_to_pixel(Vector2(i+plus, j)))

	# cria peca de soma
	var new_piece = piece_one.next_piece.instance()
	add_child(new_piece)
	new_piece.position = grid_to_pixel(Vector2(i+plus,j))

	piece_one.remove()
	piece_two.remove()
	board[i+plus][j] = null
	board[i][j] = null
	board[i+plus][j] = new_piece

func move_piece(piece, i,j ,direction):

	var temp = board[i][j]
	var value = board[i][j].value

	match direction:
		Vector2.RIGHT:
			if i ==0:
				if board[i+1][j]==null && board[i+2][j]==null && board[i+3][j]==null:
					var plus = 3
					update_one_piece(temp, i, j, plus)
					return
				if board[i+1][j]==null && board[i+2][j]==null && board[i+3][j].value==value:
					var plus = 3
					update_two_pieces(temp, board[i+plus][j],i,j,plus)
					return
				if board[i+1][j]==null && board[i+2][j]==null && board[i+3][j].value!=value:
					var plus = 2
					update_one_piece(temp, i, j, plus)
					return
				if board[i+1][j]==null && board[i+2][j].value==value:
					var plus = 2
					update_two_pieces(temp, board[i+plus][j],i,j,plus)
					return
				if board[i+1][j]==null && board[i+2][j].value!=value:
					var plus = 1
					update_one_piece(temp, i, j, plus)
					return
			if i ==1:
				if board[i+1][j]==null && board[i+2][j]==null:
					var plus = 2
					update_one_piece(temp, i, j, plus)
					return
				if board[i+1][j]==null && board[i+2][j].value==value:
					var plus = 2
					update_two_pieces(temp, board[i+plus][j],i,j,plus)
					return
				if board[i+1][j]==null && board[i+2][j].value!=value:
					var plus = 1
					update_one_piece(temp, i, j, plus)
					return
			if i ==2:
				if board[i+1][j]==null :
					var plus = 1
					update_one_piece(temp, i, j ,plus)
					return
				if board[i+1][j].value==value :
					var plus = 1
					update_two_pieces(temp, board[i+plus][j], i, j ,plus)
					return
				

func move_right():
	var temp_new_position
	var piece = board[0][0]
	for j in height:
		for i in [2,1,0]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.RIGHT)
				printar()
func move_left():
	pass

func move_up():
	pass

func move_down():
	pass

func _input(_event):
	if Input.is_action_just_pressed('ui_right'):
		move_right()
	if Input.is_action_just_pressed('ui_left'):
		move_left()
	if Input.is_action_just_pressed('ui_down'):
		move_down()
	if Input.is_action_just_pressed('ui_up'):
		move_up()

func made_bg():
	for j in height:
		for i in width:
			var p = default.instance()
			p.position = grid_to_pixel(Vector2(i,j))
			add_child(p)
			pos_matrix[i][j] = grid_to_pixel(Vector2(i,j)) 


func generate_piece():
	randomize()
	var pos_x = randi()%3 + 1

	randomize()
	var pos_y = randi()%3 + 1

	if board[pos_x][pos_y]==null:
		var temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false


func one_piece_generate(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func printar():
	for i in [0,1,2,3]:
		print(board[i])
	print(" ")

func _ready():
	made_bg()
	#generate_piece()
	one_piece_generate(0,0)
	one_piece_generate(1,0)
	one_piece_generate(2,0)
	one_piece_generate(3,0)
	#printar()
	pass # Replace with function body.



