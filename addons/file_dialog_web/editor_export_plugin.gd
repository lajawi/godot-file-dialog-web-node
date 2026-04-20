extends EditorExportPlugin


func _get_name() -> String:
	return "FileDialogWeb"


@warning_ignore("unused_parameter")
func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if features.has("web"):
		const PATH := "res://addons/file_dialog_web/file_dialog_web.js"
		var file := FileAccess.open(PATH, FileAccess.READ)
		var content := file.get_as_text().to_utf8_buffer()
		add_file(PATH, content, false)
