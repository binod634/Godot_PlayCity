extends Node3D


var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
var ADDRESS  :String

# for udp discovery
var udp = PacketPeerUDP.new()
var my_thread := Thread.new()
var discoveryPort = 8999
var broadcastIp := "255.255.255.255"
var hasFoundServer := false

func _ready() -> void:
	$Control/CanvasLayer/join.visible = false
	udp.bind(discoveryPort)
	pass

func _process(delta: float) -> void:
	if udp.get_available_packet_count() > 0 && not hasFoundServer:
		var array_bytes = udp.get_packet()
		var packet_string = array_bytes.get_string_from_ascii()
		print("Received message:------------------------------------------------------------------------------------------------------------------------------------ ", packet_string)
		ADDRESS = packet_string
		hasFoundServer = true
		$Control/CanvasLayer/join.visible = true

	
	
func _send_udp_ping():
	udp.set_broadcast_enabled(true)
	udp.bind(9999)
	var ping_message = "DISCOVER_SERVER"
	var result = udp.set_dest_address(broadcastIp,discoveryPort)
	if result != OK:
		print("something went wrong",result)
		return
		
	my_thread.start(_send_regularly_udp_packets)
	
	
	
func _send_regularly_udp_packets()->void:
	var address = get_primary_local_address()
	if address == "":
		print("address empty")
		return
	while true:
		udp.put_packet(address.to_utf8_buffer())
		await get_tree().create_timer(1.0).timeout

func _on_host_pressed() -> void:
	var result = peer.create_server(1027)
	if (result != OK):
		print("Failed to create server...")
		return
	else:
		print("created server")
	_send_udp_ping()
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id())
	$Control/CanvasLayer.visible = false

func remove_player(id:int):
	get_node(str(id)).queue_free()

func add_player(id : int):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func _on_join_pressed() -> void:
	var result = peer.create_client(ADDRESS,1027)
	if result != OK:
		print("Failed to connect to server...")
		return
	else:
		print("connected to server")
	multiplayer.multiplayer_peer = peer
	$Control/CanvasLayer.visible = false
	




func exit_game(id := 1):
	rpc("free_player_from_game",id)



@rpc("any_peer","call_local")
func free_player_from_game(id :int):
	get_node(str(id)).queue_free()

func get_primary_local_address() -> String:
	var addresses = IP.get_local_addresses()
	for address in addresses:
		if address != "127.0.0.1" and (address.begins_with("192.168.") or address.begins_with("10.") or address.begins_with("172.")):
			return address
	if addresses.size() > 0:
		print("Warning: No private IP found, using first address: ", addresses[0])
		return addresses[0]
	else:
		print("Error: No local addresses available")
		return ""  # Handle this case as needed (e.g., disable UDP send)
