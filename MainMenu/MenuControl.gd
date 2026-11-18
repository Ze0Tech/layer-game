extends Control

#Variables / Setup
@onready var Main : MenuPanel = $MainMenu
@onready var Settings : SettingsPanel = $SettingsMenu

func _ready() -> void:
	Main.visible = true
	Settings.visible = false
	
func Start() -> void:
	if get_tree():
		get_tree().change_scene_to_file("res://LevelSelect/level_select.tscn")

func Exit() -> void:
	get_tree().quit()
	
#Button Signals /////////////////////////////////////////

func _on_start_button_down() -> void:
	Main.StartSpr.frame = 1


func _on_start_button_up() -> void:
	Main.StartSpr.frame = 0
	call_deferred('Start')

func _on_settings_button_down() -> void:
	Main.SettingsSpr.frame = 1


func _on_settings_button_up() -> void:
	Main.SettingsSpr.frame = 0
	Main.visible = false
	Settings.visible = true


func _on_exit_button_down() -> void:
	Main.ExitSpr.frame = 1
	

func _on_exit_button_up() -> void:
	Main.ExitSpr.frame = 0
	Exit()


func _on_back_button_down() -> void:
	Settings.BackSpr.frame = 1


func _on_back_button_up() -> void:
	Settings.BackSpr.frame = 0
	Main.visible = true
	Settings.visible = false
