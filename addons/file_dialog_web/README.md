# Godot `FileDialogWeb` Node

A ready-made Godot [`FileDialog`](https://docs.godotengine.org/en/stable/classes/class_filedialog.html) that just works™ in the browser.

## Usage

First and foremost, [install and enable](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html) the plugin.

1. Add the `FileDialogWeb` Node to your scene
2. Set `Access` to `File System`
3. Set `Use Native Dialog` to true
4. Configure the rest
	- `File Mode`
	- `Filters`
	- ...
5. In code, connect to the available signals depending on platform (`OS.has_feature("web")`)
6. In code, act on those signals, also depending on platform

For a more details example, check out [`option_button.gd`](/option_button.gd). To see this example project in action, clone it, open it in Godot, and then run in browser.
