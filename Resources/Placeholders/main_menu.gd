extends Control

@onready var ButtonSound = $ButtonSound
@onready var StartSprite = $"Container/Panel/Start/64x20SpriteSheet"
@onready var SettingsSprite = $"Container/Panel/Settings/64x20SpriteSheet2"
@onready var ExitSprite = $"Container/Panel/Exit/64x20SpriteSheet3"
@onready var BackSprite = $"Container/Panel2/Back/64x20SpriteSheet3"
@onready var HighestScoreLabel = $HighestScore
@onready var MainPanel = $Container/Panel
@onready var SettingsPanel = $Container/Panel2
@onready var Music : AudioStreamPlayer = $AudioStreamPlayer
@onready var MusicSlider := $Container/Panel2/Music
@onready var SFXSlider := $Container/Panel2/SFX
@onready var BackgroundCover := $Backgroundtemp
@onready var ControlButton := $Container/Panel2/Control
@onready var Set1 := $Backgroundtemp/Set1
@onready var Set2 := $Backgroundtemp/Node2D
@onready var Thankyou := $Backgroundtemp/Node2D/HighestScore4

signal meh

func _ready() -> void:
	Thankyou.visible = false
	Set1.visible = true
	Set2.modulate = Color(0.0, 0.0, 0.0, 0.0)
	Set2.visible = true
	MainPanel.visible = true
	SettingsPanel.visible = false
	BackgroundCover.visible = true
	var tween = create_tween()
	if FileAccess.file_exists('user://savegame.save'):
		var file = FileAccess.open('user://savegame.save',FileAccess.READ)
		var HighestScore : int
		Globals.HighestScore = file.get_var(HighestScore)
	
	
	MusicSlider.value = Globals.MusicMod
	SFXSlider.value = Globals.SFXMod
	
func _process(delta: float) -> void:
	Music.volume_db = -8 + Globals.MusicMod
	ButtonSound.volume_db = 0.0 + Globals.SFXMod
	
func StartGame():
	get_tree().change_scene_to_file("res://Game.tscn")



func _on_start_button_down() -> void:
	StartSprite.frame = 1
	ButtonSound.pitch_scale = 0.85
	ButtonSound.play()
	pass # Replace with function body.


func _on_settings_button_down() -> void:
	SettingsSprite.frame = 1
	ButtonSound.pitch_scale = 0.85
	ButtonSound.play()
	pass # Replace with function body.


func _on_exit_button_down() -> void:
	ExitSprite.frame = 1
	ButtonSound.pitch_scale = 0.85
	ButtonSound.play()
	pass # Replace with function body.


func _on_start_button_up() -> void:
	StartSprite.frame = 0
	ButtonSound.pitch_scale = 1.15
	ButtonSound.play()
	call_deferred('StartGame')


func _on_settings_button_up() -> void:
	SettingsSprite.frame = 0
	ButtonSound.pitch_scale = 1.15
	ButtonSound.play()
	MainPanel.visible = false
	SettingsPanel.visible = true
	pass # Replace with function body.


func _on_exit_button_up() -> void:
	var tween= create_tween()
	Thankyou.visible = true
	Set1.visible = false
	Set2.modulate = Color(1.0, 1.0, 1.0, 1.0)
	tween.tween_property(BackgroundCover,'modulate',Color(1.0, 1.0, 1.0, 1.0),2)
	tween.tween_await(self.meh).set_timeout(10)
	ExitSprite.frame = 0
	ButtonSound.pitch_scale = 1.15
	ButtonSound.play()
	tween.tween_callback(queue_free)
	
	pass # Replace with function body.


func _on_back_button_down() -> void:
	BackSprite.frame = 1
	ButtonSound.pitch_scale = 0.85
	ButtonSound.play()
	pass # Replace with function body.


func _on_back_button_up() -> void:
	BackSprite.frame = 0
	ButtonSound.pitch_scale = 1.15
	ButtonSound.play()
	SettingsPanel.visible = false
	MainPanel.visible = true
	pass # Replace with function body.

func _on_music_value_changed(value: float) -> void:
	Globals.MusicMod = MusicSlider.value
	print(Globals.MusicMod)
	pass # Replace with function body.


func _on_sfx_value_changed(value: float) -> void:
	Globals.SFXMod = SFXSlider.value
	pass # Replace with function body.


func _on_control_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	if toggled_on:
		Globals.AltControl = true
		ControlButton.get_child(0).frame = 1
		ControlButton.text = 'On'
	else: 
		Globals.AltControl = false
		ControlButton.get_child(0).frame = 0
		ControlButton.text = 'Off'
	pass # Replace with function body.
