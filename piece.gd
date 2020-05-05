extends Node2D

export var value:int
export var next_piece:PackedScene
 
onready var move_tween := $MoveTween

func _ready():
	pass

func move(new_position: Vector2):
	move_tween.interpolate_property(self, "position", position, new_position, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	move_tween.start()

func remove():
	queue_free()
