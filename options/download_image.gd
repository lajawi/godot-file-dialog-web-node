extends Node


@export var _image: Texture2D

@onready var _dialog: FileDialogWeb = %DownloadDialogWeb
@onready var _option_button: OptionButton = $".."


func _ready() -> void:
	if not OS.has_feature("web"):
		_dialog.file_selected.connect(_on_file_selected)


func trigger() -> void:
	var image := _image.get_image()

	_dialog.file_buffer = image.save_png_to_buffer()
	_dialog.current_file = _image.resource_path.get_file()
	_dialog.popup_file_dialog_web()


func _on_file_selected(path: String) -> void:
	if not _option_button.selected == Options.DOWNLOAD_IMAGE:
		return

	var img := _image.get_image()
	var ext := _image.resource_path.get_extension().to_lower()
	match ext:
		"png":
			img.save_png(path)
		"jpg", "jpeg":
			img.save_jpg(path)
