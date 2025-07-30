extends Label

var level_time = 0.0
var timer_active = false

func _ready():
	level_time = 0.0
	timer_active = true
	text = "0:00"  # Initialize the label text

func _process(delta):
	if timer_active:
		level_time += delta
		update_timer_display()

func update_timer_display():
	var minutes = int(level_time / 60)
	var seconds = int(level_time) % 60
	text = "%d:%02d" % [minutes, seconds]

func stop_timer():
	timer_active = false
	var final_time = format_final_time()
	print("Level completed in: ", final_time)
	return final_time

func format_final_time() -> String:
	var minutes = int(level_time / 60) 
	var seconds = int(level_time) % 60
	var milliseconds = int((level_time - int(level_time)) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
