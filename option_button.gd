extends OptionButton


const DOWNLOAD_TEXT := 1
const DOWNLOAD_IMAGE := 2
const UPLOAD_TEXT := 4
const UPLOAD_IMAGE := 5

@export_group("Dialogs", "_dialog")
@export var _dialog_web_download: FileDialogWeb
@export var _dialog_web_upload_text: FileDialogWeb
@export var _dialog_web_upload_image: FileDialogWeb

@export_group("Example Files", "_file")
@export_file var _file_text_path: String
@export var _file_image: Texture2D

@export_group("UI", "_ui")
@export var _ui_text: Label
@export var _ui_image: TextureRect


func _ready() -> void:
	if OS.has_feature("web"):
		_dialog_web_upload_text.web_file_selected.connect(_on_web_file_selected)
		_dialog_web_upload_image.web_file_selected.connect(_on_web_file_selected)
	else:
		_dialog_web_download.file_selected.connect(_on_file_selected)
		_dialog_web_upload_text.file_selected.connect(_on_file_selected)
		_dialog_web_upload_image.file_selected.connect(_on_file_selected)


#region Option Button Selected
func _on_item_selected(index: int) -> void:
	match index:
		DOWNLOAD_TEXT:
			_download_text()
		DOWNLOAD_IMAGE:
			_download_image()
		UPLOAD_TEXT:
			_upload_text()
		UPLOAD_IMAGE:
			_upload_image()
		_:
			return


func _download_text() -> void:
	var file := FileAccess.open(_file_text_path, FileAccess.READ)
	var _text := file.get_as_text()
	file.close()

	_dialog_web_download.file_buffer = _text.to_utf8_buffer()
	_dialog_web_download.current_file = _file_text_path.get_file()
	_dialog_web_download.popup_file_dialog_web()


func _download_image() -> void:
	var image := _file_image.get_image()

	_dialog_web_download.file_buffer = image.save_png_to_buffer()
	_dialog_web_download.current_file = _file_image.resource_path.get_file()
	_dialog_web_download.popup_file_dialog_web()


func _upload_text() -> void:
	_dialog_web_upload_text.popup_file_dialog_web()


func _upload_image() -> void:
	_dialog_web_upload_image.popup_file_dialog_web()
#endregion


#region Normal File Dialog Handling
func _on_file_selected(path: String) -> void:
	match selected:
		DOWNLOAD_TEXT:
			var file := FileAccess.open(_file_text_path, FileAccess.READ)
			var dest := FileAccess.open(path, FileAccess.WRITE)
			dest.store_string(file.get_as_text())
			dest.close()
		DOWNLOAD_IMAGE:
			var img := _file_image.get_image()
			var ext := _file_image.resource_path.get_extension().to_lower()
			match ext:
				"png":
					img.save_png(path)
				"jpg", "jpeg":
					img.save_jpg(path)
		UPLOAD_TEXT:
			var file := FileAccess.open(path, FileAccess.READ)
			var _text := file.get_as_text()
			file.close()
			_display_upload(_text)
		UPLOAD_IMAGE:
			var image := Image.load_from_file(path)
			var texture := PortableCompressedTexture2D.new()
			texture.create_from_image(image, PortableCompressedTexture2D.COMPRESSION_MODE_LOSSLESS)
			_display_upload("", texture)
#endregion


#region Web File Dialog Handling
func _on_web_file_selected(file: FileDialogWeb.File) -> void:
	match file.type.split("/")[0]:
		"text":
			_process_upload_text(file)
		"image":
			_process_upload_image(file)


func _process_upload_text(file: FileDialogWeb.File) -> void:
	_display_upload(file.data)


func _process_upload_image(file: FileDialogWeb.File) -> void:
	var data = Marshalls.base64_to_raw(file.data)
	var image := Image.new()

	match file.type:
		"image/png":
			image.load_png_from_buffer(data)
		"image/jpeg":
			image.load_jpg_from_buffer(data)

	var texture := PortableCompressedTexture2D.new()
	texture.create_from_image(image, PortableCompressedTexture2D.COMPRESSION_MODE_LOSSLESS)
	_display_upload("", texture)
#endregion


#region Show Data
func _display_upload(_text: String = "", texture: Texture2D = null) -> void:
	_ui_text.text = _text
	_ui_image.texture = texture
#endregion
