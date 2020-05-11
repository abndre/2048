extends Node

var high_score = get_high_score()

func save_hich_core():
	var file = File.new()
	var error =  file.open("user://save.data", File.WRITE)
	if not error:
		file.store_var({"high_score":high_score})
	
func get_high_score():
	var file = File.new()
	var error = file.open("user://save.data", File.READ)
	if not error:
		high_score = file.get_var()["high_score"]
	else:
		high_score=0
	return high_score
