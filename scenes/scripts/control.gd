extends Control

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene





func _on_host_pressed() -> void:
	var result = peer.create_server(1027)
	if (result != OK):
		print("Failed to create server...")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	$CanvasLayer.visible = false

func add_player(id : int):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func _on_join_pressed() -> void:
	var result = peer.create_client("127.0.0.1",1027)
	if result != OK:
		print("Failed to connect to server...")
		return
	multiplayer.multiplayer_peer = peer
	$CanvasLayer.visible = false
	




func exit_game(id := 1):
	rpc("free_player_from_game",id)



@rpc("any_peer","call_local")
func free_player_from_game(id :int):
	get_node(str(id)).queue_free()
