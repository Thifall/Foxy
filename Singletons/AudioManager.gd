extends Node

var music_stream_player: AudioStreamPlayer2D

const MAIN_MENU_SONG = preload("res://assets/sound/Farm Frolics.ogg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_stream_player = AudioStreamPlayer2D.new()
	add_child(music_stream_player)
	music_stream_player.volume_db = -25
	
func play_main_menu_music()-> void:
	if(!music_stream_player):
		print("Audio player not set")
		return
		
	if music_stream_player.playing:
		if music_stream_player.stream != MAIN_MENU_SONG:
			music_stream_player.stop()
		else:
			return		
	else:
		music_stream_player.stream = MAIN_MENU_SONG			
		music_stream_player.play()
	
