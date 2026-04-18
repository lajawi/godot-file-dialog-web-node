class_name FileDialogWeb
extends FileDialog


signal web_dir_selected(files: Array[File])
signal web_file_selected(file: File)
signal web_files_selected(files: Array[File])

@export var file: PackedByteArray

var _js_interface: JavaScriptObject
var _on_files_selected_callback: JavaScriptObject
var _on_file_uploaded_callback: JavaScriptObject

var _selected_files: Array[String]

var _data: Array[File]


func popup_file_dialog_web() -> void:
	if (
			not use_native_dialog
			or not OS.has_feature("web")
			or not access == Access.ACCESS_FILESYSTEM
	):
		return popup_file_dialog()

	match file_mode:
		FILE_MODE_OPEN_FILE,	\
		FILE_MODE_OPEN_FILES,	\
		FILE_MODE_OPEN_DIR,		\
		FILE_MODE_OPEN_ANY:
			pass
		FILE_MODE_SAVE_FILE:
			pass
		_:
			return popup_file_dialog()

	var js_file := FileAccess.open("res://addons/file-dialog-web/file_dialog_web.js", FileAccess.READ)
	var js := js_file.get_as_text()

	JavaScriptBridge.eval(js, true)

	_js_interface = JavaScriptBridge.get_interface("fileDialogWeb")

	_on_files_selected_callback = JavaScriptBridge.create_callback(_on_files_selected)
	_js_interface.setFilesSelectedCallback(_on_files_selected_callback)

	_on_file_uploaded_callback = JavaScriptBridge.create_callback(_on_file_uploaded)
	_js_interface.setFileUploadedCallback(_on_file_uploaded_callback)

	_js_interface.setFilters(",".join(filters))
	_js_interface.setFileMode(file_mode)

	_selected_files.clear()
	_data.clear()
	_js_interface.popupFileDialog()


func _on_files_selected(args: Array) -> void:
	_selected_files.assign(args)


func _on_file_uploaded(args: Array) -> void:
	var l_file = File.new(args[0], args[1], args[2], args[3])
	_data.append(l_file);

	if _selected_files.size() == _data.size():
		_send_signal()


func _send_signal() -> void:
	match file_mode:
		FILE_MODE_OPEN_FILE, FILE_MODE_OPEN_ANY:
			web_file_selected.emit(_data[0])
		FILE_MODE_OPEN_FILES:
			web_files_selected.emit(_data)
		FILE_MODE_OPEN_DIR:
			web_dir_selected.emit(_data)
		_:
			return


class File:
	var name: String
	var relativePath: String
	var type: String
	var data: String

	func _init(p_name: String, p_relativePath: String, p_type: String, p_data: String) -> void:
		name = p_name
		relativePath = p_relativePath
		type = p_type
		data = p_data
