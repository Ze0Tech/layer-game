extends RigidBody2D

func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_DISABLED
	
	var KillTimer : Timer = Timer.new()
	add_child(KillTimer)
	KillTimer.timeout.connect(End)
	KillTimer.wait_time = 2
	KillTimer.start()
	
func End() -> void:
	self.queue_free()
