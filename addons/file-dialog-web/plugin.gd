@tool
extends EditorPlugin


const JsEditorExportPlugin = preload("res://addons/file-dialog-web/editor_export_plugin.gd")
var export_plugin = JsEditorExportPlugin.new()


func _enter_tree() -> void:
	add_export_plugin(export_plugin)
	pass


func _exit_tree() -> void:
	remove_export_plugin(export_plugin)
	pass
