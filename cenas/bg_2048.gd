extends Node2D


var vectorx=[170-40, 252-40, 334-40, 416-40]
var vectory=[400-40, 482-40, 564-40, 646-40]

var font

func mkfont(fsize):
	var fnt = DynamicFont.new()
	fnt.size = fsize
	fnt.set_font_data(load("res://8-bit-pusab.ttf"))
	return fnt

func _draw():
	font = mkfont(32)
	for j in range(4):
		for i in range(4):
			draw_rect(Rect2(vectorx[i], vectory[j], 80.0, 80.0), ColorN("gray"), true)

	#draw_string(font, Vector2(160,420), "16", Color(1.0, 1.0, 0.0))
