extends Node


@onready var _dialog: FileDialogWeb = %UploadMultipleImagesDialogWeb
@onready var _option_button: OptionButton = $".."


func _ready() -> void:
	if OS.has_feature("web"):
		_dialog.web_files_selected.connect(_on_web_files_selected)
	else:
		_dialog.files_selected.connect(_on_files_selected)


func trigger() -> void:
	_dialog.popup_file_dialog_web()


func _on_web_files_selected(files: Array[FileDialogWeb.File]) -> void:
	if not _option_button.selected == Options.UPLOAD_IMAGES:
		return

	var _text := "\n".join(files.map(func(f): return f.relativePath.path_join(f.name)))
	_option_button.display_upload(_text)


func _on_files_selected(paths: PackedStringArray) -> void:
	if not _option_button.selected == Options.UPLOAD_IMAGES:
		return

	var _text := "\n".join(paths)
	_option_button.display_upload(_text)
