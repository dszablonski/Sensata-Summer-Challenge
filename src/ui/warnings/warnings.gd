extends PanelContainer

const LIMITS_POPUP_SIZE_RATIO := 0.38

onready var limits_popup: Popup = $LimitsPopup


func _on_PingButton_pressed() -> void:  # TODO
	print("Ping button pressed!")


func _on_LimitsButton_pressed() -> void:
	limits_popup.popup_centered()
