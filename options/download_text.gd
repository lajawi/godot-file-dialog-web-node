extends Node


@export_file var _text_file: String

@onready var _dialog: FileDialogWeb = %DownloadDialogWeb
@onready var _option_button: OptionButton = $".."


func _ready() -> void:
	if not OS.has_feature("web"):
		_dialog.file_selected.connect(_on_file_selected)


func trigger() -> void:
	var file := FileAccess.open(_text_file, FileAccess.READ)
	var _text := file.get_as_text()
	file.close()

	_dialog.file_buffer = _text.to_utf8_buffer()
	_dialog.current_file = _text_file.get_file()
	_dialog.popup_file_dialog_web()


func _on_file_selected(path: String) -> void:
	if not _option_button.selected == Options.DOWNLOAD_TEXT:
		return

	var file := FileAccess.open(_text_file, FileAccess.READ)
	var dest := FileAccess.open(path, FileAccess.WRITE)
	dest.store_string(file.get_as_text())
	dest.close()
