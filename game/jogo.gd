extends Node2D

var score = 0
var high_socre= 0

var width := 4
var height :=4

var x := 180
var y := 400
var plus := 82

onready var default = preload("res://cenas/default.tscn")
onready var twopiece = preload("res://pieces/2piece.tscn")
onready var fourpiece = preload("res://pieces/4piece.tscn")

var board = [[null,null,null,null],[null,null,null,null],[null,null,null,null],[null,null,null,null]]	
var pos_matrix =  [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

func update_score(piece):
	score += int(piece.value *2)
	$placar/score.text = str(score)
	if high_socre < score:
		high_socre = score
	$placar/high_score.text = str(high_socre)

func grid_to_pixel(grid: Vector2):
		return Vector2(x + grid.x*plus, y + grid.y*plus)

func update_piece(piece, i, j):
	var n_piece = piece.next_piece.instance()
	add_child(n_piece)
	n_piece.position = grid_to_pixel(Vector2(i,j))
	board[i][j] = n_piece

func update_one_piece(piece, i, j, plus_x, plus_y=0):
	piece.move(grid_to_pixel(Vector2(i+plus_x, j+plus_y)))
	board[i][j] =null
	board[i+plus_x][j+plus_y] =piece



func update_two_pieces(piece_one, piece_two, i, j , plus_x, plus_y=0):
	# move a peca
	var vector = Vector2(i+plus_x, j+plus_y)
	piece_one.move(grid_to_pixel(vector))

	# cria peca de soma
	var new_piece = piece_one.next_piece.instance()
	add_child(new_piece)
	new_piece.position = grid_to_pixel(vector)

	piece_one.remove()
	piece_two.remove()

	board[i+plus_x][j+plus_y] = null
	board[i][j] = null
	board[i+plus_x][j+plus_y] = new_piece
	
	update_score(piece_one)

func thirth_piece(temp, i,j, left=1):
	var value = temp.value
	var board_1 = board[i+1*left][j]
	var board_2 = board[i+2*left][j]
	var board_3 = board[i+3*left][j]

	if board_1==null && board_2==null && board_3==null:
		var plus = 3*left
		update_one_piece(temp, i, j, plus)
		return true
	if board_1==null && board_2==null && board_3.value==value:
		var plus = 3*left
		update_two_pieces(temp, board[i+plus][j],i,j,plus)
		return true
	if board_1==null && board_2==null && board_3.value!=value:
		var plus = 2*left
		update_one_piece(temp, i, j, plus)
		return true
	return false

func second_piece(temp, i, j, left = 1):
	var value = temp.value
	var board_1 = board[i+1*left][j]
	var board_2 = board[i+2*left][j]

	if board_1==null && board_2==null:
		var plus = 2*left
		update_one_piece(temp, i, j, plus)
		return true
	if board_1==null && board_2.value==value:
		var plus = 2*left
		update_two_pieces(temp, board[i+plus][j],i,j,plus)
		return true
	if board_1==null && board_2.value!=value:
		var plus = 1*left
		update_one_piece(temp, i, j, plus)
		return true
	return false

func first_piece(temp, i,j, left=1):
	var value = temp.value
	var board_1 = board[i+1*left][j]
	if board_1==null :
		var plus = 1*left
		update_one_piece(temp, i, j ,plus)
		return true
	if board_1.value==value :
		var plus = 1*left
		update_two_pieces(temp, board[i+plus][j], i, j ,plus)
		return true
	return false

func move_piece(piece, i,j ,direction):

	var temp = board[i][j]
	var value = temp.value

	match direction:
		Vector2.RIGHT:
			if i ==0:
				if thirth_piece(temp, i, j): 
					return
				if second_piece(temp, i, j):
					return
				if first_piece(temp, i, j):
					return
			if i ==1:
				if second_piece(temp, i, j):
					return
				if first_piece(temp, i, j):
					return
			if i ==2:
				if first_piece(temp, i, j):
					return
		Vector2.LEFT:
			var left = -1
			if i ==3:
				if thirth_piece(temp, i, j, left): 
					return

				if second_piece(temp, i, j, left):
					return
				if first_piece(temp, i, j, left):
					return

			if i ==2:
				if second_piece(temp, i, j, left):
					return
				if first_piece(temp, i, j, left):
					return
			if i ==1:
				if first_piece(temp, i, j, left):
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
	var temp_new_position
	var piece = board[0][0]
	for j in height:
		for i in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.LEFT)
				printar()

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

func one_piece_generate_2(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate_4(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = fourpiece.instance()
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
	one_piece_generate_2(0,0)
	one_piece_generate_2(1,0)
	one_piece_generate_2(2,0)
	one_piece_generate_2(3,0)
	#printar()
	$placar/score.text = str(score)
	$placar/high_score.text = str(high_socre)
	pass # Replace with function body.

func _on_reload_pressed():
	get_tree().reload_current_scene()



