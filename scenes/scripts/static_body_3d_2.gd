extends StaticBody3D


func _ready() -> void:
	if visible == false:
		$CollisionShape3D.disabled = true
