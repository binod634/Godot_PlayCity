extends Sprite3D


func _process(delta: float) -> void:
	var player_health = $"../".player_health
	scale.x = player_health
