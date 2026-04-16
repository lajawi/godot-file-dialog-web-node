// @ts-check

const FileModeOpenFile	= 0
const FileModeOpenFiles	= 1
const FileModeOpenDir	= 2
const FileModeOpenAny	= 3
const FileModeSaveFile	= 4

const RegFilterAsterisk = /\*\./;
const RegFilterName = /;.+;/;

let input = document.createElement("input");
input.setAttribute("type", "file");

/** @param {string} filters */
const setFilters = (filters) => {
	filters = filters.replace(RegFilterAsterisk, ".");
	filters = filters.replace(RegFilterName, ",");

	input.setAttribute("accept", filters);
};

/** @param {number} fileMode */
const setFileMode = (fileMode) => {
	switch (fileMode) {
		case FileModeOpenDir:
			input.setAttribute("directory", "");
			input.setAttribute("webkitdirectory", "");
		case FileModeOpenFiles:
			input.setAttribute("multiple", "");
			break;
		default:
			break;
	}
};

let fileSelected;
/** @param {any} onFileSelected */
const setFileSelectedCallback = (onFileSelected) => fileSelected = onFileSelected;

const popupFileDialog = () => {
	input.click();
};


function fileDialogWebInit() {
	let _interface = {
		setFilters,
		setFileMode,
		setFileSelectedCallback,
		popupFileDialog,
	}

	return _interface;
}

var fileDialogWeb = fileDialogWebInit();
