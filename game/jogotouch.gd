extends Node2D

var score = 0
var high_socre = data.get_high_score()

var width := 4
var height :=4

var x := 180.0
var y := 400.0
var plus := 82.0
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

func grid_to_pixel(grid: Vector2):
		return Vector2(float(x + grid.x*plus), float(y + grid.y*plus))

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

func move_piece(_piece, i,j ,direction):

	var temp = board[i][j]


	match direction:
		Vector2.RIGHT:
			if i ==0:
				if thirth_piece(temp, i, j): 
					return

			return
		Vector2.LEFT:
			var left = -1
			if i ==3:
				if thirth_piece(temp, i, j, left): 
					return
			return
		Vector2.DOWN:
			if j ==0:
				if thirth_piece_y(temp, i, j): 
					return

			return
		Vector2.UP:
			var left = -1
			if j ==3:
				if thirth_piece_y(temp, i, j, left): 
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


func move_left():

	var piece = board[0][0]
	for j in height:
		for i in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.LEFT)


func move_up():

	var piece = board[0][0]
	for i in width:
		for j in [1,2,3]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.UP)


func move_down():

	var piece = board[0][0]
	for i in width:
		for j in [2,1,0]:
			if board[i][j] != null:
				move_piece(piece, i,j, Vector2.DOWN)

func _start_detection(position: Vector2) -> void:
	swipe_start_position = position


func _end_detection(position: Vector2) -> void:

	var direction: Vector2 = (position - swipe_start_position).normalized()
	print(" ")
	print(direction)

func _input(event):

	if Input.is_action_just_pressed('ui_right'):
		move_right()

	if Input.is_action_just_pressed('ui_left'):
		move_left()

	if Input.is_action_just_pressed('ui_down'):
		move_down()

	if Input.is_action_just_pressed('ui_up'):
		move_up()

	if event is InputEventScreenTouch:
		if (event.position.y > 230):
			if (event.pressed==true): # pressed
	
				swipe_start_position = event.position
			elif (event.pressed==false): #release
				var direction = event.position - swipe_start_position
				#var direct = direction.normalized()
				var angle = rad2deg(direction.angle())
				print(angle) 
				if angle > 160.0 && angle < 180:
					print("left 1")
					move_left()
					return
				elif angle < -160.0 && angle > -180:
					print("left 2")
					move_left()
					return
				elif angle > 0 && angle <30:
					print("right 1")
					move_right()
					return
				elif angle < -1 && angle > -30:
					print("right 2")
					move_right()
					return
				elif angle < 120 && angle > 50:
					print("down")
					move_down()
					return
				elif angle > -120 && angle < -50:
					print("up")
					move_up()
					return
					
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


func one_piece_generate_2(pos_x, pos_y):
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

func _ready():
	made_bg()
	one_piece_generate_2(0,0)

