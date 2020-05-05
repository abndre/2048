extends Node2D


var width := 4
var height :=4

var x := 160
var y := 400
var plus := 82

onready var default = preload("res://cenas/default.tscn")
onready var twopiece = preload("res://pieces/2piece.tscn")

var matrix = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]


#var matrix = [[null,null,null,null],[null,null,null,null],[null,null,null,null],[null,null,null,null]]

var pos_matrix =  [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

var obj_matriz = [[null,null,null,null],[null,null,null,null],[null,null,null,null],[null,null,null,null]]	

func space_blank():
	for j in height:
		for i in width-1:
			if matrix[i][j]==0:
				return true
	return false

func move_all_pieces(direction: Vector2):
	match direction:
		Vector2.UP:
			pass
		Vector2.DOWN:
			pass
		Vector2.RIGHT:
			print("right")
		Vector2.LEFT:
			pass
		_:
			continue
 
func move_right():
	for j in height:
		for i in width:
			pass
		print(matrix[j])

func grid_to_pixel(grid: Vector2):
		return Vector2(x + grid.x*plus, y + grid.y*plus)

func move_and_set_board_value(current:Vector2, new_position:Vector2):
	var temp = obj_matriz[current.x][current.y] 
	temp.move(grid_to_pixel(new_position))
	obj_matriz[current.x][current.y] = null
	obj_matriz[new_position.x][new_position.y]=temp

func move_piece(piece: Vector2, direction: Vector2):
	
	var this_piece = obj_matriz[piece.x][piece.y]
	var value = this_piece.value
	
	var next_space =  piece + direction
	
	var next_value = obj_matriz[next_space.x][next_space.y]
	
	match direction:
		Vector2.RIGHT:
			for i in range(next_space.x, width):
				# fim da borda e o lado e nulo
				if i == width -1 && obj_matriz[i][piece.y]==null:
					move_and_set_board_value(piece, Vector2(width -1, piece.y))
					break
				# borda eo valor nao o mesmo
				if obj_matriz[i][piece.y] !=null && obj_matriz[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i-1, piece.y))
					break
				# boarda cheio e valor o mesmo
				if obj_matriz[i][piece.y] !=null && obj_matriz[i][piece.y].value == value:
					var temp = obj_matriz[piece.x][piece.y].next_piece
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					var new_piece = temp.instance()
					add_child(new_piece)
					obj_matriz[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
		Vector2.LEFT:
			for i in range(next_space.x, -1, -1):
				# fim da borda e o lado e nulo
				if i == 0 && obj_matriz[i][piece.y]==null:
					move_and_set_board_value(piece, Vector2(0, piece.y))
					break
				# borda eo valor nao o mesmo
				if obj_matriz[i][piece.y] !=null && obj_matriz[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i-1, piece.y))
					break
				# boarda cheio e valor o mesmo
				if obj_matriz[i][piece.y] !=null && obj_matriz[i][piece.y].value == value:
					var temp = obj_matriz[piece.x][piece.y].next_piece
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					var new_piece = temp.instance()
					add_child(new_piece)
					obj_matriz[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
		Vector2.DOWN:
			pass
		Vector2.UP:
			pass


func remove_and_clear(piece: Vector2):
	obj_matriz[piece.x][piece.y].remove()
	obj_matriz[piece.x][piece.y] = null

func _input(event):
	if Input.is_action_pressed('ui_right'):
		for j in width:
			for i in height-1:
				if obj_matriz[i][j] != null:
					move_piece(Vector2(i,j), Vector2.RIGHT)
	if Input.is_action_pressed('ui_left'):
		for j in width:
			for i in range(height -1, -1, -1):
				if obj_matriz[i][j] != null:
					move_piece(Vector2(i,j), Vector2.LEFT)
	if Input.is_action_pressed('ui_down'):
		for i in width:
			for j in range(height -1, -1, -1):
				if obj_matriz[i][j] != null:
					move_piece(Vector2(i,j), Vector2.DOWN)
	if Input.is_action_pressed('ui_up'):
		for j in width:
			for i in height - 1:
				if obj_matriz[i][j] != null:
					move_piece(Vector2(i,j), Vector2.UP)


func one_piece_generate():
	randomize()
	var pos_x = randi()%3 + 1
	randomize()
	var pos_y = randi()%3 + 1
	if matrix[pos_x][pos_y]==0:
		matrix[pos_x][pos_y] = 2
		var temp = twopiece.instance()
		temp.position = pos_matrix[pos_x][pos_y]
		add_child(temp)
		obj_matriz[pos_x][pos_y] = temp
		return true
	return false

func generate_piece():
	if space_blank():
		var generated_piece = 0
		while generated_piece <= 1:
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
			

func _ready():
	made_bg()
	generate_piece()
