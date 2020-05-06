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

func move_and_set_board_value(current:Vector2, new_position:Vector2):
	var temp = board[current.x][current.y] 
	temp.move(grid_to_pixel(new_position))
	board[current.x][current.y] = null
	board[new_position.x][new_position.y]=temp

func remove_and_clear(piece: Vector2):
	board[piece.x][piece.y].remove()
	board[piece.x][piece.y] = null

func move_piece(piece: Vector2, direction: Vector2):
	var this_piece = board[piece.x][piece.y]
	var value = this_piece.value
	var temp = board[piece.x][piece.y].next_piece
	var next_space =  piece + direction

	match direction:
		Vector2.RIGHT:
			for i in range(next_space.x, width):
				# fim da borda e o lado e nulo
				if i == width -1 && board[i][piece.y]==null:
					move_and_set_board_value(piece, Vector2(width -1, piece.y))
					break
				# borda eo valor nao o mesmo
				if board[i][piece.y] !=null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i-1, piece.y))
					break
				# boarda cheio e valor o mesmo
				if board[i][piece.y] !=null && board[i][piece.y].value == value:
					#var temp = board[piece.x][piece.y].next_piece
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
		Vector2.LEFT:
			for i in range(next_space.x, -1, -1):
				# fim da borda e o lado e nulo
				if i == 0 && board[i][piece.y]==null:
					move_and_set_board_value(piece, Vector2(0, piece.y))
					break
				# borda eo valor nao o mesmo
				if board[i][piece.y] !=null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i-1, piece.y))
					break
				# boarda cheio e valor o mesmo
				if board[i][piece.y] !=null && board[i][piece.y].value == value:
					#var temp = board[piece.x][piece.y].next_value
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
		Vector2.DOWN:
			for i in range(piece.y -1, -1, -1):
				# fim da borda e o lado e nulo
				if i == 0 && board[i][piece.y]==null:
					move_and_set_board_value(piece, Vector2(piece.x, 0))
					break
				# borda eo valor nao o mesmo
				if board[i][piece.y] !=null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i+1))
					break
				# boarda cheio e valor o mesmo
				if board[piece.x][i] !=null && board[piece.x][i].value == value:
					#var temp = board[piece.x][piece.y].next_value
					remove_and_clear(piece)
					remove_and_clear(Vector2(piece.x, i))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(piece.x, i))
					break
		Vector2.UP:
			for i in range(piece.y + 1, height):
				# fim da borda e o lado e nulo
				if i == height -1 && board[piece.x][i]==null:
					move_and_set_board_value(piece, Vector2(piece.x, height - 1))
					break
				# borda eo valor nao o mesmo
				if board[piece.x][i] !=null && board[piece.x][i].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i-1))
					break
				# boarda cheio e valor o mesmo
				if board[piece.x][i] !=null && board[piece.x][i].value == value:
					#var temp = board[piece.x][piece.y].next_piece
					remove_and_clear(piece)
					remove_and_clear(Vector2(piece.x, i))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[piece.x][i] = new_piece
					new_piece.position = grid_to_pixel(Vector2(piece.x, i))
					break

func move_right():
	var temp_new_position
	for j in height:
		for i in range(width-2,-1,-1):
			if board[i][j] != null:
				move_piece(Vector2(i,j), Vector2.RIGHT)

func move_left():
	var temp_new_position
	for j in height:
		for i in range(1, width, 1):
			if board[i][j] != null:
				var piece_value = board[i][j].value
				move_piece(Vector2(i,j), Vector2.LEFT)

func move_up():
	for i in width:
		for j in range(height-2, -1, -1):
			if board[i][j] != null:
				move_piece(Vector2(i,j), Vector2.UP)

func move_down():
	for i in width:
		for j in range(0, height, 1):
			if board[i][j] != null:
				move_piece(Vector2(i,j), Vector2.DOWN)

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
	pos_x=1
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

func one_piece_generate():
	randomize()
	var pos_x = randi()%3 + 1
	pos_x=1
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

func _ready():
	made_bg()
	one_piece_generate()
	#one_piece_generate2()
	#generate_piece()
