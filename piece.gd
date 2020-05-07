extends Node2D

export var value:int
export var next_piece:PackedScene
 
onready var move_tween := $MoveTween
onready var size_tween := $SizeTween
onready var module_tweeb := $ModulateTween

func _ready():
	pop_in()
	pass

func pop_in():
	size_tween.interpolate_property(self,"scale", Vector2(0.1,0.1), Vector2(1,1),0.2,Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()

func move(new_position: Vector2):
	move_tween.interpolate_property(self, "position", position, new_position, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	move_tween.start()

func remove():
	size_tween.interpolate_property(self, "scale", Vector2(1.5, 1.5), 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	module_tweeb.interpolate_property(self, "modulate", modulate, Color(0,0,0,0), 0.2,Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()
	module_tweeb.start()



func _on_ModulateTween_tween_completed(object, key):
	if scale == Vector2(1.5, 1.5):
		queue_free()

