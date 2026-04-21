extends Node


@onready var _dialog: FileDialogWeb = %UploadFolderDialogWeb
@onready var _option_button: OptionButton = $".."


func _ready() -> void:
	if OS.has_feature("web"):
		_dialog.web_dir_selected.connect(_on_web_dir_selected)
	else:
		_dialog.dir_selected.connect(_on_dir_selected)


func trigger() -> void:
	_dialog.popup_file_dialog_web()


func _on_web_dir_selected(files: Array[FileDialogWeb.File]) -> void:
	if not _option_button.selected == Options.UPLOAD_FOLDER:
		return

	var _text := "\n".join(files.map(func(f): return f.relativePath))
	_option_button.display_upload(_text)


func _on_dir_selected(dir: String) -> void:
	if not _option_button.selected == Options.UPLOAD_FOLDER:
		return

	_option_button.display_upload(dir)
