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

func one_piece_generate():
	randomize()
	var pos_x = randi()%3 + 1
	pos_x=2
	randomize()
	var pos_y = randi()%3 + 1
	pos_y=1
	if board[pos_x][pos_y]==null:
		var temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

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

func made_bg():
	for j in height:
		for i in width:
			var p = default.instance()
			p.position = grid_to_pixel(Vector2(i,j))
			add_child(p)
			pos_matrix[i][j] = grid_to_pixel(Vector2(i,j)) 

func remove_piece_from_board(remove: Vector2):
	board[remove.x][remove.y] = null

func add_piece_to_board(position: Vector2, value):
	board[position.x][position.y] = value

func change_piece(temp_new_position, i,j):
	board[i][j].move(grid_to_pixel(temp_new_position)) 
	add_piece_to_board(temp_new_position, board[i][j])
	remove_piece_from_board(Vector2(i,j))

func merge_piece(piece, i, j):
	var temp = piece.next_piece.instance()
	remove_piece_from_board(Vector2(i,j))
	board[i][j] = temp
	add_child(temp)
	temp.position = grid_to_pixel(Vector2(i,j))

func move_right():
	var temp_new_position
	for j in height:
		for i in range(width-2,-1,-1):
			if board[i][j] != null:
				var piece_value = board[i][j].value
				# movimentar sem pecas no caminho
				if i==2 && board[i+1][j]==null:
					temp_new_position = Vector2(i+1, j)
					change_piece(temp_new_position, i, j)
				elif i==2 && board[i+1][j].value==piece_value:
					temp_new_position = Vector2(i+1, j)
					change_piece(temp_new_position, i, j)
					merge_piece(board[i+1][j], i+1, j)
				elif i==1 && board[i+1][j]==null && board[i+2][j]==null:
					temp_new_position = Vector2(i+2, j)
					change_piece(temp_new_position, i, j)
				elif i==1 && board[i+1][j]==null && board[i+2][j].value != null:
					temp_new_position = Vector2(i+1, j)
					change_piece(temp_new_position, i, j)
				elif i==0 && board[i+1][j]==null && board[i+2][j]==null && board[i+3][j]==null:
					temp_new_position = Vector2(i+3, j)
					change_piece(temp_new_position, i, j)
				elif i==0 && board[i+1][j]==null && board[i+2][j]!=null && board[i+3][j]!=null:
					temp_new_position = Vector2(i+1, j)
					change_piece(temp_new_position, i, j)
				elif i==0 && board[i+1][j]==null && board[i+2][j]==null && board[i+3][j]!=null:
					temp_new_position = Vector2(i+2, j)
					change_piece(temp_new_position, i, j)

func move_left():
	var temp_new_position
	for j in height:
		for i in range(1, width, 1):
			if board[i][j] != null:
				var piece_value = board[i][j].value
				# movimentar sem pecas no caminho
				if i==3 && board[i-1][j]==null && board[i-2][j]==null && board[i-3][j]==null:
					temp_new_position = Vector2(i-3, j)
					change_piece(temp_new_position, i, j)
				elif i==3 && board[i-1][j]==null && board[i-2][j]!=null && board[i-3][j]!=null:
					temp_new_position = Vector2(i-1, j)
					change_piece(temp_new_position, i, j)
				elif i==3 && board[i-1][j]==null && board[i-2][j]==null && board[i-3][j]!=null:
					temp_new_position = Vector2(i-2, j)
					change_piece(temp_new_position, i, j)
				elif i==2 && board[i-1][j]==null && board[i-2][j]==null:
					temp_new_position = Vector2(i-2, j)
					change_piece(temp_new_position, i, j)
				elif i==2 && board[i-1][j]==null && board[i-2][j]!=null:
					temp_new_position = Vector2(i-1, j)
					change_piece(temp_new_position, i, j)
				elif i==1 && board[i-1][j]==null:
					temp_new_position = Vector2(i-1, j)
					change_piece(temp_new_position, i, j)

func move_up():
	var temp_new_position
	for i in height:
		for j in range(1, width, 1):
			if board[i][j] != null:
				var piece_value = board[i][j].value
				# movimentar sem pecas no caminho
				if j==1 && board[i][j-1]==null:
					temp_new_position = Vector2(i, j-1)
					#change_piece(temp_new_position, i, j)
				elif j==2 && board[i][j-1]==null && board[i][j-2]==null:
					temp_new_position = Vector2(i, j-2)
					#change_piece(temp_new_position, i, j)
				elif j==3 && board[i][j-1]==null && board[i][j-2]==null && board[i][j-3]==null:
					temp_new_position = Vector2(i, j-3)
				change_piece(temp_new_position, i, j)

func move_down():
	var temp_new_position
	for i in height:
		for j in range(width-2,-1,-1):
			if board[i][j] != null:
				var piece_value = board[i][j].value
				# movimentar sem pecas no caminho
				if j==2 && board[i][j+1]==null:
					temp_new_position = Vector2(i, j+1)
					#change_piece(temp_new_position, i, j)
				elif j==1 && board[i][j+1]==null && board[i][j+2]==null:
					temp_new_position = Vector2(i, j+2)
				#	#change_piece(temp_new_position, i, j)
				elif j==0 && board[i][j+1]==null && board[i][j+2]==null && board[i][j+3]==null:
					temp_new_position = Vector2(i, j+3)
				#temp_new_position = Vector2(i, j+1)
				change_piece(temp_new_position, i, j)

func _input(_event):
	if Input.is_action_just_pressed('ui_right'):
		move_right()
	if Input.is_action_just_pressed('ui_left'):
		move_left()
	if Input.is_action_just_pressed('ui_down'):
		move_down()
	if Input.is_action_just_pressed('ui_up'):
		move_up()

func one_piece_generate2():
	randomize()
	var pos_x = randi()%3 + 1
	pos_x=2
	randomize()
	var pos_y = randi()%3 + 1
	pos_y=2
	if board[pos_x][pos_y]==null:
		var temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false


func _ready():
	made_bg()
	one_piece_generate()
	#one_piece_generate2()
	#generate_piece()
