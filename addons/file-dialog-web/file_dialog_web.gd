class_name FileDialogWeb
extends FileDialog


@export var file: PackedByteArray

var _js_interface: JavaScriptObject
var _on_file_selected_callback: JavaScriptObject

@onready var console = JavaScriptBridge.get_interface("console")


func popup_file_dialog_web() -> void:
	if not use_native_dialog or not OS.has_feature("web"):
		return popup_file_dialog()

	match file_mode:
		FILE_MODE_OPEN_FILE:	# 0
			pass
		FILE_MODE_OPEN_FILES:	# 1
			pass
		FILE_MODE_OPEN_DIR:		# 2
			pass
		FILE_MODE_SAVE_FILE:	# 4
			pass
		FILE_MODE_OPEN_ANY, _:
			return popup_file_dialog()

	var js_file := FileAccess.open("res://addons/file-dialog-web/file_dialog_web.js", FileAccess.READ)
	var js := js_file.get_as_text()

	JavaScriptBridge.eval(js, true)

	_js_interface = JavaScriptBridge.get_interface("fileDialogWeb")
	_on_file_selected_callback = JavaScriptBridge.create_callback(_on_file_selected)

	_js_interface.setFilters(",".join(filters))
	_js_interface.setFileMode(file_mode)
	_js_interface.popupFileDialog()


func _on_file_selected(args: Array) -> void:
	console.log(args)
