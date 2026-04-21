extends Node


@onready var _dialog: FileDialogWeb = %UploadTextDialogWeb
@onready var _option_button: OptionButton = $".."


func _ready() -> void:
	if OS.has_feature("web"):
		_dialog.web_file_selected.connect(_on_web_file_selected)
	else:
		_dialog.file_selected.connect(_on_file_selected)


func trigger() -> void:
	_dialog.popup_file_dialog_web()


func _on_web_file_selected(file: FileDialogWeb.File) -> void:
	if not _option_button.selected == Options.UPLOAD_TEXT:
		return

	if not file.type.begins_with("text"):
		return

	_option_button.display_upload(file.data)


func _on_file_selected(path: String) -> void:
	if not _option_button.selected == Options.UPLOAD_TEXT:
		return

	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	_option_button.display_upload(text)
