extends CSGCombiner3D

func _ready() -> void:
	if visible == false:
		queue_free()
