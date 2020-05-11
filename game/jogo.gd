extends Node2D

var score = 0
var high_socre= 0

var width := 4
var height :=4

var x := 180.0
var y := 400.0
var plus := 82.0

var dead = 0

onready var default = preload("res://cenas/default.tscn")
onready var twopiece = preload("res://pieces/2piece.tscn")
onready var fourpiece = preload("res://pieces/4piece.tscn")
onready var oitopiece = preload("res://pieces/8piece.tscn")
onready var dezesseispiece = preload("res://pieces/16piece.tscn")

var board = [[null,null,null,null],[null,null,null,null],[null,null,null,null],[null,null,null,null]]	
var pos_matrix =  [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

func update_score(piece):
	score += int(piece.value *2)
	$placar/score.text = str(score)
	if high_socre < score:
		high_socre = score
	$placar/high_score.text = str(high_socre)

func grid_to_pixel(grid: Vector2):
		return Vector2(float(x + grid.x*plus), float(y + grid.y*plus))

func update_piece(piece, i, j):
	var n_piece = piece.next_piece.instance()
	add_child(n_piece)
	n_piece.position = grid_to_pixel(Vector2(i,j))
	board[i][j] = n_piece

func update_one_piece(piece, i, j, plus_x, plus_y=0):
	piece.move(grid_to_pixel(Vector2(i+plus_x, j+plus_y)))

	board[i+plus_x][j+plus_y] =piece
	#board[i][j].dead()
	board[i][j] =null

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
	#board[i][j].dead()
	#board[i+plus_x][j+plus_y].dead()
	board[i+plus_x][j+plus_y] = null
	board[i][j] = null
	board[i+plus_x][j+plus_y] = new_piece
	
	update_score(piece_one)

func thirth_piece_y(temp, i,j, left=1):
	var value = temp.value
	var board_1 = board[i][j+1*left]
	var board_2 = board[i][j+2*left]
	var board_3 = board[i][j+3*left]

	if board_1==null && board_2==null && board_3==null:
		var plus = 3*left
		update_one_piece(temp, i, j,0, plus)
		return true
	if board_1==null && board_2==null && board_3.value==value:
		var plus = 3*left
		update_two_pieces(temp, board[i][j+plus],i,j,0,plus)
		return true
	if board_1==null && board_2==null && board_3.value!=value:
		var plus = 2*left
		update_one_piece(temp, i, j, 0,plus)
		return true
	return false

func second_piece_y(temp, i, j, left = 1):
	var value = temp.value
	var board_1 = board[i][j+1*left]
	var board_2 = board[i][j+2*left]

	if board_1==null && board_2==null:
		var plus = 2*left
		update_one_piece(temp, i, j,0, plus)
		return true
	if board_1==null && board_2.value==value:
		var plus = 2*left
		update_two_pieces(temp, board[i][j+plus],i,j,0,plus)
		return true
	if board_1==null && board_2.value!=value:
		var plus = 1*left
		update_one_piece(temp, i, j,0, plus)
		return true
	return false

func first_piece_y(temp, i,j, left=1):
	var value = temp.value
	var board_1 = board[i][j+1*left]
	if board_1==null :
		var plus = 1*left
		update_one_piece(temp, i, j ,0,plus)
		return true
	if board_1.value==value :
		var plus = 1*left
		update_two_pieces(temp, board[i][j+plus], i, j ,0,plus)
		return true
	return false

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

func move_piece(_piece, i,j ,direction):

	var temp = board[i][j]


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
			return
		Vector2.DOWN:
			if j ==0:
				if thirth_piece_y(temp, i, j): 
					return
				if second_piece_y(temp, i, j):
					return
				if first_piece_y(temp, i, j):
					return
			if j ==1:
				if second_piece_y(temp, i, j):
					return
				if first_piece_y(temp, i, j):
					return
			if j ==2:
				if first_piece_y(temp, i, j):
					return
			return
		Vector2.UP:
			var left = -1
			if j ==3:
				if thirth_piece_y(temp, i, j, left): 
					return
				if second_piece_y(temp, i, j, left):
					return
				if first_piece_y(temp, i, j, left):
					return
			if j ==2:
				if second_piece_y(temp, i, j, left):
					return
				if first_piece_y(temp, i, j, left):
					return
			if j ==1:
				if first_piece_y(temp, i, j, left):
					return
			return
		_:
			continue

func move_right():
	var piece = board[0][0]
	for j in height:
		for i in [2,1,0]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.RIGHT)
				#printar()

func move_left():

	var piece = board[0][0]
	for j in height:
		for i in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.LEFT)
				#printar()

func move_up():
	var piece = board[0][0]
	for i in width:
		for j in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.UP)
				#printar()

func move_down():

	var piece = board[0][0]
	for i in width:
		for j in [2,1,0]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.DOWN)
				#printar()

func _input(_event):
	if Input.is_action_just_pressed('ui_right'):
		move_right()
		generate_piece_game()
		#print("right")
		#printar()
	if Input.is_action_just_pressed('ui_left'):
		move_left()
		generate_piece_game()
		#print("left")
		#printar()
	if Input.is_action_just_pressed('ui_down'):
		move_down()
		generate_piece_game()
		#print("down")
		#printar()
	if Input.is_action_just_pressed('ui_up'):
		move_up()
		generate_piece_game()
		#print("up")
		#printar()

func made_bg():
	for j in height:
		for i in width:
			var p = default.instance()
			p.position = grid_to_pixel(Vector2(i,j))
			add_child(p)
			pos_matrix[i][j] = grid_to_pixel(Vector2(i,j)) 

func generate_piece():
	var temp
	randomize()
	var pos_x = randi()%3 + 1

	randomize()
	var pos_y = randi()%3 + 1

	if board[pos_x][pos_y]==null:
		randomize()
		var two_or_four = randi()%20 + 1
		if two_or_four == 1:
			temp = fourpiece.instance()
		else:
			temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate(pos_x, pos_y):
	var temp
	var two_or_four = randi()%20 + 1
	if two_or_four == 1:
		temp = fourpiece.instance()
	else:
		temp = twopiece.instance()
	temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
	add_child(temp)
	board[pos_x][pos_y] = temp


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

func one_piece_generate_8(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = oitopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate_16(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = dezesseispiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func printar():
	var lin = [0,1,2,3]
	var p
	var s
	var t
	var q
	for i in [0,1,2,3]:
		if board[lin[0]][i]!=null:
			p = board[lin[0]][i].value
		else:
			p=0
		if board[lin[1]][i]!=null:
			s = board[lin[1]][i].value
		else:
			s=0
		if board[lin[2]][i]!=null:
			t = board[lin[2]][i].value
		else:
			t=0
		if board[lin[3]][i]!=null:
			q = board[lin[3]][i].value
		else:
			q=0
		print(p, " ", s, " ", t, " ", q)
	print(" ")

func is_space_blank():
	for j in [0,1,2,3]:
		for i in [0,1,2,3]:
			if board[i][j]==null:
				return true
	return false

func get_null_pieces():
	var vetor :=[]
	for j in [0,1,2,3]:
		for i in [0,1,2,3]:
			if board[i][j]==null:
				vetor.append([i,j])
	return vetor

func generate_piece_game():

	var pieces = get_null_pieces()
	if len(pieces) == 0:
		print("No more Room!!!")
		dead +=1
		if dead >=4:
			print("end game")
			get_tree().paused = true
			$endgame.visible = true
	else:
		var rand = randi()%len(pieces)
		one_piece_generate(pieces[rand][0], pieces[rand][1])

func _ready():
	#$endgame.visible = false
	made_bg()
	generate_piece_game()
	generate_piece_game()
	#generate_piece()
	#generate_piece()
	#var col
	
	#col =0
	#one_piece_generate_2(0,col)
	#one_piece_generate_2(1,col)
	#one_piece_generate_2(2,col)
	#one_piece_generate_2(2,0)
	#one_piece_generate_2(3,0)


	#col = 1
	#one_piece_generate_4(0,col)
	#one_piece_generate_4(1,col)
	#one_piece_generate_4(2,col)
	#col = 2
	#one_piece_generate_8(0,col)
	#one_piece_generate_8(1,col)
	#one_piece_generate_8(2,col)
	#one_piece_generate_2(1,col)
	#one_piece_generate_2(2,col)
	#one_piece_generate_2(3,col)
	
	#col = 3
	#one_piece_generate_16(0,col)
	#one_piece_generate_16(1,col)
	#one_piece_generate_16(2,col)
	#one_piece_generate_2(1,col)
	#one_piece_generate_2(2,col)
	#one_piece_generate_2(3,col)

	#printar()
	$placar/score.text = str(score)
	$placar/high_score.text = str(high_socre)
	pass # Replace with function body.

func _on_reload_pressed():
	return get_tree().reload_current_scene()

func _on_restart_end_game_pressed():
	get_tree().paused = false
	$endgame.visible = false
	return get_tree().reload_current_scene()



func _on_close_pressed():
	get_tree().paused = false
	$endgame.visible = false
