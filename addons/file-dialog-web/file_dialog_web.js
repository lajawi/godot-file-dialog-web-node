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

/** @type {CallableFunction} */
let filesSelectedCallback;
/** @param {any} onFilesSelected */
const setFilesSelectedCallback = (onFilesSelected) => filesSelectedCallback = onFilesSelected;

/** @type {CallableFunction} */
let fileUploadedCallback;
/** @param {any} onFileUploaded */
const setFileUploadedCallback = (onFileUploaded) => fileUploadedCallback = onFileUploaded;

const popupFileDialog = () => {
	input.click();
};

/** @param {any} event */
input.onchange = (event) => {
	/** @type {HTMLInputElement} */
	let target = event.target;
	if (!target) {
		return;
	}

	let files = target.files;
	if (!files) {
		return;
	}

	/** @type {Array<String>} */
	let selectedFiles = [];

	for (let file of files) {
		selectedFiles.push(file.name);
	}

	filesSelectedCallback(...selectedFiles);

	for (let file of files) {
		let fileName = file.name;
		let relativePath = file.webkitRelativePath;
		let type = file.type;

		let reader = new FileReader();

		if (type.startsWith("text/"))
			reader.readAsText(file);
		else
			reader.readAsDataURL(file);

		reader.onload = (readerEvent) => {
			if (!readerEvent.target) {
				return;
			}

			if (readerEvent.target.readyState !== FileReader.DONE) {
				return;
			}

			let data = readerEvent.target.result;

			if (typeof(data) !== "string") {
				return;
			}

			if (!type.startsWith("text/"))
				data = data.split(",")[1];

			fileUploadedCallback(fileName, relativePath, type, data);
		}
	}
};


function fileDialogWebInit() {
	let _interface = {
		setFilters,
		setFileMode,
		setFilesSelectedCallback,
		setFileUploadedCallback,
		popupFileDialog,
	}

	return _interface;
}

var fileDialogWeb = fileDialogWebInit();
