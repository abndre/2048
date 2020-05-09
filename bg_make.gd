extends Node2D


var width := 4
var height :=4

var x := 160
var y := 400
var plus := 82


var x_start := 180
var y_start := 650
var offset := 82


onready var default = preload("res://cenas/default.tscn")
onready var twopiece = preload("res://pieces/2piece.tscn")
onready var fourpiece = preload("res://pieces/4piece.tscn")

var matrix = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

var pos_matrix =  [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

var board = [[null,null,null,null],[null,null,null,null],[null,null,null,null],[null,null,null,null]]

#var board 

func is_space_blank():
	for j in height:
		for i in width-1:
			if board[i][j]==null:
				return true
	return false

#func grid_to_pixel(grid: Vector2):
#		return Vector2(x + grid.x*plus, y + grid.y*plus)

func grid_to_pixel(grid_position: Vector2):
	var new_x = x_start + offset * grid_position.x
	var new_y = y_start + -offset * grid_position.y
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_position: Vector2):
	var new_x = round((pixel_position.x-x_start)/offset)
	var new_y = round((pixel_position.y-y_start)/-offset)
	return Vector2(new_x, new_y)


func is_in_grid(grid_position: Vector2):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true
	return false


func move_and_set_board_value(current:Vector2, new_position:Vector2):
	var temp = board[current.x][current.y] 
	temp.move(grid_to_pixel(Vector2(new_position.x, new_position.y)))
	board[current.x][current.y] = null
	board[new_position.x][new_position.y]=temp

func move_piece(piece: Vector2, direction: Vector2):
	
	var this_piece = board[piece.x][piece.y]
	var value = this_piece.value
	var temp = board[piece.x][piece.y].next_piece
	var next_space =  piece + direction
	
	#var next_value = board[next_space.x][next_space.y]
	
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
				if i == 0 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(piece.x, 0))
					break
				# borda eo valor nao o mesmo
				if board[i][piece.y] !=null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i + 1))
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


func remove_and_clear(piece: Vector2):
	board[piece.x][piece.y].remove()
	board[piece.x][piece.y] = null

func _input(_event):
	if Input.is_action_just_pressed('ui_right'):
		move_all_pieces(Vector2.RIGHT)
	if Input.is_action_just_pressed('ui_left'):
		move_all_pieces(Vector2.LEFT)
	if Input.is_action_just_pressed('ui_down'):
		move_all_pieces(Vector2.DOWN)
	if Input.is_action_just_pressed('ui_up'):
		move_all_pieces(Vector2.UP)

func move_all_pieces(direction: Vector2):
	match direction:
		Vector2.RIGHT:
			for i in range(width -1, -1, -1):
				for j in height:
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.RIGHT)
		Vector2.LEFT:
			for i in range(1, width, 1):
				for j in height:
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.LEFT)
		Vector2.UP:
			for i in width:
				for j in range(height-2, -1,-1):
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.UP)
		Vector2.DOWN:
			print("down")
			for i in width:
				for j in range(0, height, 1):
					if board[i][j] != null:
						print("find", i, " ", j)
						move_piece(Vector2(i,j), Vector2.DOWN)
		_:
			continue
	#generate_piece(0)

func one_piece_generate():
	var temp
	#randomize()
	#var pos_x = randi()%3 + 1
	#randomize()
	#var pos_y = randi()%3 + 1
	var pos_x = 1
	var pos_y = 0
	if matrix[pos_x][pos_y]==0:
		matrix[pos_x][pos_y] = 2
		randomize()
		var piece_value = randi()%10 + 1
		if piece_value == 10:
			temp = fourpiece.instance()
		else:
			temp = twopiece.instance()
		temp.position = pos_matrix[pos_x][pos_y]
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate0(pos_x: int, pos_y:int):
	var temp
	if matrix[pos_x][pos_y]==0:
		matrix[pos_x][pos_y] = 2
		randomize()
		var piece_value = randi()%10 + 1
		if piece_value == 10:
			temp = fourpiece.instance()
		else:
			temp = twopiece.instance()
		temp.position = pos_matrix[pos_x][pos_y]
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func generate_piece(number_of_pieces: int):
	if is_space_blank():
		var generated_piece = 0
		while generated_piece < number_of_pieces:
			if one_piece_generate():
				generated_piece +=1 
	else:
		print("No more Room!!!")

func made_bg():
	for j in height:
		for i in width:
			var p = default.instance()
			p.position = grid_to_pixel(Vector2(i,j))
			add_child(p)
			pos_matrix[i][j] = grid_to_pixel(Vector2(i,j)) 
			

func made_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array.append(null)
	return array

func _ready():
	#board = made_2d_array()
	made_bg()
	#generate_piece(0)
	one_piece_generate0(3,3)
	one_piece_generate0(2,3)
	one_piece_generate0(1,3)
	one_piece_generate0(0,3)
	#one_piece_generate()
	#one_piece_generate0()


func _on_restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
