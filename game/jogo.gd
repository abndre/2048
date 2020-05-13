extends Node2D

var score = 0
var high_socre = data.get_high_score()

var width := 4
var height :=4

var x := 120.0
var y := 400.0
var plus := 120.0
var can_move = true
var dead = 0

var back_board = [null,null,null,null, null]

var swipe_start_position: = Vector2()

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
		data.high_score = high_socre
		data.save_hich_core()
	$placar/high_score.text = str(high_socre)

func grid_to_pixel(grid: Vector2):
		return Vector2(float(x + grid.x*plus), float(y + grid.y*plus))

func update_piece(piece, i, j):
	var n_piece = piece.next_piece.instance()
	$pieces.add_child(n_piece)
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
	$pieces.add_child(new_piece)
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

func voltar():
	back_board.pop_front()
	var temp :=[]
	for j in height:
		var t2 =[]
		for i in width:
			if board[i][j] !=null:
				t2.append(board[i][j].value)
			else:
				t2.append(0)
		temp.append(t2)
	back_board.append(temp)


func move_right():
	voltar()
	var piece = board[0][0]
	for j in height:
		for i in [2,1,0]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.RIGHT)


func move_left():
	voltar()
	var piece = board[0][0]
	for j in height:
		for i in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.LEFT)


func move_up():
	voltar()
	var piece = board[0][0]
	for i in width:
		for j in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.UP)


func move_down():
	voltar()
	var piece = board[0][0]
	for i in width:
		for j in [2,1,0]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.DOWN)

func pieces_game():
		generate_piece_game()
		$next_move.start()
		can_move = false

func _input(event):
	
	if $play.visible ==true:
		return
	
	#if $next_move.get_time_left() < 0:
	#	return
	
	if can_move == false:
		return
	
	if Input.is_action_just_pressed('ui_right'):
		move_right()
		pieces_game()

	if Input.is_action_just_pressed('ui_left'):
		move_left()
		pieces_game()
	if Input.is_action_just_pressed('ui_down'):
		move_down()
		pieces_game()
	if Input.is_action_just_pressed('ui_up'):
		move_up()
		pieces_game()

	if event is InputEventScreenTouch:
		if (event.position.y > 230):
			if (event.pressed==true): # pressed
	
				swipe_start_position = event.position
			elif (event.pressed==false): #release
				var direction = event.position - swipe_start_position
				#var direct = direction.normalized()
				var angle = rad2deg(direction.angle())
				#print(angle) 
				if angle > 160.0 && angle < 180:
					#print("left 1")
					move_left()
					pieces_game()
					return
				elif angle < -160.0 && angle > -180:
					#print("left 2")
					move_left()
					pieces_game()
					return
				elif angle > 0 && angle <30:
					#print("right 1")
					move_right()
					pieces_game()
					return
				elif angle < -1 && angle > -30:
					#print("right 2")
					move_right()
					pieces_game()
					return
				elif angle < 120 && angle > 50:
					#print("down")
					move_down()
					pieces_game()
					return
				elif angle > -120 && angle < -50:
					#print("up")
					move_up()
					pieces_game()
					return

func made_bg():
	for j in height:
		for i in width:
			var p = default.instance()
			p.position = grid_to_pixel(Vector2(i,j))
			$pieces.add_child(p)
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
		$pieces.add_child(temp)
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
	$pieces.add_child(temp)
	board[pos_x][pos_y] = temp

func one_piece_generate_2(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = twopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		$pieces.add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate_4(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = fourpiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		$pieces.add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate_8(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = oitopiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		$pieces.add_child(temp)
		board[pos_x][pos_y] = temp
		return true
	return false

func one_piece_generate_16(pos_x, pos_y):
	if board[pos_x][pos_y]==null:
		var temp = dezesseispiece.instance()
		temp.position = grid_to_pixel(Vector2(pos_x, pos_y))
		$pieces.add_child(temp)
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
	$endgame.visible = false
	made_bg()
	$placar/score.text = str(score)
	$placar/high_score.text = str(high_socre)


func _on_reload_pressed():
	get_tree().reload_current_scene()


func _on_restart_end_game_pressed():
	get_tree().paused = false
	$endgame.visible = false
	return get_tree().reload_current_scene()

func _on_close_pressed():
	get_tree().paused = false
	$endgame.visible = false


func _on_voltar_pressed():
	print("rodada")
	for j in height:
		for i in width:
			var temp = board[i][j]
			if temp != null:
				temp.dead()
				board[i][j] = null



func _on_play_pressed():
	generate_piece_game()
	generate_piece_game()
	$play.visible = false
	$pieces.visible = true
	pass # Replace with function body.


func _on_next_move_timeout():
	can_move = true

func printar_bg_2(bor):
	
	var lin = [0,1,2,3]
	var p
	var s
	var t
	var q
	for i in [0,1,2,3]:
		p = bor[lin[0]][i]
		s = bor[lin[1]][i]
		t = bor[lin[2]][i]
		q = bor[lin[3]][i]
		print(p, " ", s, " ", t, " ", q)
	print(" ")

func printar_bg(bor):
	for i in bor:
		print(i)
	print(" ")
