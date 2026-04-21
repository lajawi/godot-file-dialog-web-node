extends Node


@onready var _dialog: FileDialogWeb = %UploadImageDialogWeb
@onready var _option_button: OptionButton = $".."


func _ready() -> void:
	if OS.has_feature("web"):
		_dialog.web_file_selected.connect(_on_web_file_selected)
	else:
		_dialog.file_selected.connect(_on_file_selected)


func trigger() -> void:
	_dialog.popup_file_dialog_web()


func _on_web_file_selected(file: FileDialogWeb.File) -> void:
	if not _option_button.selected == Options.UPLOAD_IMAGE:
		return

	if not file.type.begins_with("image"):
		return

	var data = Marshalls.base64_to_raw(file.data)
	var image := Image.new()

	match file.type:
		"image/png":
			image.load_png_from_buffer(data)
		"image/jpeg":
			image.load_jpg_from_buffer(data)

	var texture := PortableCompressedTexture2D.new()
	texture.create_from_image(image, PortableCompressedTexture2D.COMPRESSION_MODE_LOSSLESS)
	_option_button.display_upload("", texture)


func _on_file_selected(path: String) -> void:
	if not _option_button.selected == Options.UPLOAD_IMAGE:
		return

	var image := Image.load_from_file(path)
	var texture := PortableCompressedTexture2D.new()
	texture.create_from_image(image, PortableCompressedTexture2D.COMPRESSION_MODE_LOSSLESS)
	_option_button.display_upload("", texture)
