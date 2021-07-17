extends Node

export var game_start_delay := 1.5

var music_is_faded := false
var music_fade_time := 2.0

onready var n_BG : ParallaxLayer = $ParallaxBackground/BG
onready var n_BackHills : ParallaxLayer = $ParallaxBackground/BackHills
onready var n_Hills : ParallaxLayer = $ParallaxBackground/Hills
onready var n_Floor : TileMap = $Floor
onready var n_Decor : TileMap = $Decor
onready var n_Player : KinematicBody2D = $Player
onready var n_SlideshowWarps : Node2D = $SlideshowWarps
onready var n_SlideshowLayer : CanvasLayer = $SlideshowLayer
onready var n_Music : AudioStreamPlayer = $Music
onready var n_Tween : Tween = $Tween
onready var n_AnimationPlayer : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	n_Player.frozen = true
	n_Player.modulate = Color.transparent
	n_Floor.modulate = Color.transparent
	n_BG.visible = true
	n_BG.modulate = Color.transparent
	n_BackHills.visible = true
	n_BackHills.modulate = Color.transparent
	n_Hills.visible = true
	n_Hills.modulate = Color.transparent
	n_SlideshowWarps.modulate = Color.transparent
	n_Decor.modulate = Color.transparent
	
	_connect_signals()
	_do_intro()


func _connect_signals() -> void:
	if n_SlideshowWarps.get_child_count() == 0:
		return
	
	for _warp in n_SlideshowWarps.get_children():
		_warp.connect("player_entered_warp", self, "fade_out_music")
		_warp.connect("player_exited_warp", self, "fade_in_music")


func _do_intro() -> void:
	yield(get_tree().create_timer(game_start_delay), "timeout")
	
	n_Music.play()
	n_AnimationPlayer.play("title_intro")
	yield(n_AnimationPlayer, "animation_finished")
	
	n_Tween.interpolate_property(n_Player, "modulate", n_Player.modulate, Color.white, 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	n_Tween.interpolate_property(n_Floor, "modulate", n_Floor.modulate, ColorManager.light_color, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.interpolate_property(n_BG, "modulate", Color(ColorManager.dark_color) * Color(1, 1, 1, 0), ColorManager.dark_color, 0.4, Tween.TRANS_SINE, Tween.EASE_IN, 0.7)
	n_Tween.interpolate_property(n_BackHills, "modulate", Color(ColorManager.primary_color) * Color(1, 1, 1, 0), ColorManager.primary_color, 0.4, Tween.TRANS_SINE, Tween.EASE_IN, 0.9)
	n_Tween.interpolate_property(n_Hills, "modulate", Color(ColorManager.primary_color) * Color(1, 1, 1, 0), ColorManager.primary_color, 0.4, Tween.TRANS_SINE, Tween.EASE_IN, 1.1)
	n_Tween.interpolate_property(n_Decor, "modulate", Color(ColorManager.complimentary_color) * Color(1, 1, 1, 0), ColorManager.complimentary_color, 0.4, Tween.TRANS_SINE, Tween.EASE_IN, 1.3)
	n_Tween.interpolate_property(n_SlideshowWarps, "modulate", n_SlideshowWarps.modulate, Color.white, 0.4, Tween.TRANS_SINE, Tween.EASE_IN, 1.4)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	n_Player.frozen = false


func fade_in_music() -> void:
	if not music_is_faded:
		return
	music_is_faded = false
	
	var _music_lowpass_effect : AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 0)
	n_Tween.interpolate_property(_music_lowpass_effect, "cutoff_hz", 1000, 17000, music_fade_time, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.interpolate_property(_music_lowpass_effect, "resonance", 0.2, 1.0, music_fade_time, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.interpolate_property(n_Music, "volume_db", -5, 0, music_fade_time, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.start()


func fade_out_music() -> void:
	if music_is_faded:
		return
	music_is_faded = true
	
	var _music_lowpass_effect : AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 0)
	n_Tween.interpolate_property(_music_lowpass_effect, "cutoff_hz", 17000, 1000, music_fade_time, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.interpolate_property(_music_lowpass_effect, "resonance", 1.0, 0.2, music_fade_time, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.interpolate_property(n_Music, "volume_db", 0, -5, music_fade_time, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.start()
