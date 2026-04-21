class_name Options
extends OptionButton


const DOWNLOAD_TEXT := 1
const DOWNLOAD_IMAGE := 2
const UPLOAD_TEXT := 4
const UPLOAD_IMAGE := 5
const UPLOAD_IMAGES := 6
const UPLOAD_FOLDER := 7

@export var _node_download_text: Node
@export var _node_download_image: Node
@export var _node_upload_text: Node
@export var _node_upload_image: Node
@export var _node_upload_images: Node
@export var _node_upload_folder: Node

@export_group("UI", "_ui")
@export var _ui_text: Label
@export var _ui_image: TextureRect


func _on_item_selected(index: int) -> void:
	match index:
		DOWNLOAD_TEXT:
			_node_download_text.trigger()
		DOWNLOAD_IMAGE:
			_node_download_image.trigger()
		UPLOAD_TEXT:
			_node_upload_text.trigger()
		UPLOAD_IMAGE:
			_node_upload_image.trigger()
		UPLOAD_IMAGES:
			_node_upload_images.trigger()
		UPLOAD_FOLDER:
			_node_upload_folder.trigger()
		_:
			return


func display_upload(_text: String = "", texture: Texture2D = null) -> void:
	_ui_text.text = _text
	_ui_image.texture = texture
