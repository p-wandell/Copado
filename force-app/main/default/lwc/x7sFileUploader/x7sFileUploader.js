/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';

import getFileRestrictions from '@salesforce/apex/x7sFileUploaderController.getFileRestrictions';
import saveChunk from '@salesforce/apex/x7sFileUploaderController.saveChunk';
import deleteAttachment from '@salesforce/apex/x7sFileUploaderController.deleteAttachment';
import loading from '@salesforce/label/c.x7sFileUploaderLabelLoading';
import errorMsg from '@salesforce/label/c.x7sFileUploaderErrorMsg';
import succcessMsg from '@salesforce/label/c.x7sFileUploaderSucccessMsg';

import {formatText, showToast, guid, inLexMode} from 'c/x7sShrUtils';

const SIZE_ABBR = ['KB','MB','GB'];
const CHUNK_SIZE = 950000;


export default class X7SFileUploader extends LightningElement {
	isInit = false;
	isLoading = false;
	showList = false;

	validList = [];
	invalidList = [];
	fileInfo = {};

	labels = {
		loading
	}

	@api recordId; // provided by LWC runtime

	@api parentId;
	@api showFileLists = false;
	@api title = 'Have an attachment?';
	@api titleAlign = 'left';
	@api message = 'If you have an attachment (such as a screenshot or other documentation) that may be helpful, add it here. {0} limit for each file. Allowed file types: {1}';
	@api uploadLabel = 'Have an attachment?';
	@api allTypesText = 'All files are accepted';
	@api validListText = 'Your attached files';
	@api invalidListText = 'These files have errors and will not be uploaded';
	@api deleteText = 'Delete file';
	@api removeText = 'Remove file from list';
	@api errorSize = 'This file was not uploaded because it exceeds the file size limit of {0}';
	@api errorExt = 'This file type is not allowed. Allowed file types are: {0}';
	@api uploadSuccessMessageSingular = 'File uploaded successfully';
	@api uploadSuccessMessagePlural = 'Files uploaded successfully';

	// if 'inForm = true' then uploadList will be maintained for external component uses
	@api inForm = false;
	@api uploadList = [];

	@api variant;
	@api customClass = '';

	/**
	 * Get file-type limits set on the community/network level and prepare
	 * UI labels and messages. Then enable the component UI (isInit = TRUE).
	 *
	 * Can set reactive properties:
	 * - isInit
	 * - fileInfo
	 */
	connectedCallback() {
		if (inLexMode()) {
			this.parentId = this.recordId;
			this.fileInfo = this.prepareFileInfo({
				AllowedExtensions: undefined, // interpreted as "all types permitted"
				MaxFileSizeKb: 4248
			});
			this.isInit = true;
		} else {
			getFileRestrictions({ /* none */ })
				.then((response) => {
					if (response.success) {
						this.fileInfo = this.prepareFileInfo(response.results[0]);
						this.isInit = true;
					} else {
						showToast(errorMsg, response.messages[0],'error', 'dismissable');
					}
				});
		}
	}

	/**
	 * Prepare 'fileInfo' with UI presentable file extensions and file upload size limits
	 *
	 * @param fi
	 * @returns {*}
	 */
	prepareFileInfo(fi) {
		if (fi.AllowedExtensions !== undefined) {
			/*
				When getting the allowed extensions the are returned as png,jpg,txt etc
				Not that pretty so we make it so it adds a space so it is easier to read
				We all translate png to PNG so we can accept both forms into the uploader
			*/
			const extensions = fi.AllowedExtensions.split(',');
			fi.fullExtensionList = extensions.map( item => item.toUpperCase() );
			fi.extensions = extensions.map( item => `.${item}` );
			fi.prettyExtensions = fi.extensions.join(', ');
		} else {
			fi.prettyExtensions = this.allTypesText;
			fi.extensions = [];
			fi.fullExtensionList = [];
		}
		/*
			Here we have to do all the conversions for the bytes.
			Javascript deals with bytes, while the community deals with KB.
			When we display the max size we want if to look pretty so we convert to MB and GB as well.
			GB just in case Salesforce ever lets us upload the full file size.
		*/
		let maxBytes = fi.MaxFileSizeKb;
		let count = 0;
		do {
			maxBytes = maxBytes / 1024;
			count += 1;
		}
		while (maxBytes > 1024);

		fi.maxFileSize = Math.round(10 * maxBytes) / 10 + ' ' + SIZE_ABBR[count];
		fi.maxSize = fi.MaxFileSizeKb * 1024;

		return fi;
	}

	/**
	 * Given an array of files from the <lightning-input> control, validate
	 * which file-types are permitted, which are not, and upload the permitted ones.
	 *
	 * Can set reactive properties:
	 * - validList
	 * - invalidList
	 * - isLoading
	 * - showList
	 *
	 * @param files
	 */
	setFileList(files) {
		this.isLoading = true;

		const fileInfo = this.fileInfo;
		let curList = [];
		files.forEach( curFile => {
			const filename = curFile.name;
			curFile.guid = guid();
			curFile.ext = filename.substr((~-filename.lastIndexOf('.') >>> 0) + 2);
			let curSize = curFile.size;
			let count = -1;
			// Getting the current uploaded file size and converting so a 2MB doesn't display as 2097152 bytes on the component
			do {
				curSize = curSize / 1024;
				count += 1;
			} while (curSize > 1024);
			curFile.formattedSize = Math.round(10 * curSize) / 10 + ' ' + SIZE_ABBR[count];
			// Checking if the current file is an accepted file type. If not we are setting an error and adding it to the rejected file list
			if (
				fileInfo.fullExtensionList.indexOf(curFile.ext.toUpperCase()) === -1 &&
				(fileInfo.hasOwnProperty('extensions') && Array.isArray(fileInfo.extensions) && fileInfo.extensions.length > 0)
			) {
				curFile.errorMessage = ' ' + fileInfo.prettyExtensions;
				curFile.errorMessageFormatted = formatText(this.errorExt, curFile.errorMessage);
				curFile.errorType = 'extension';
				curFile.valid = false;
				this.invalidList.push(curFile);
				// Checking if the current file size less then the allowed max file size. If not we are setting an error and adding it to the rejected file list
			} else if (curFile.size > fileInfo.maxSize) {
				curFile.errorMessage = ' ' + fileInfo.maxFileSize;
				curFile.errorMessageFormatted = formatText(this.errorSize, curFile.errorMessage);
				curFile.errorType = 'size';
				curFile.valid = false;
				this.invalidList.push(curFile);
			} else {
				// If no error add the to the accepted file list
				curFile.errorType = null;
				curFile.valid = true;
				this.validList.push(curFile);
				// File uploader in a form add the file to the upload list to be uploaded later, else will add it to the file list to be uploaded right away
				if (this.inForm) {
					this.uploadList.push(curFile);
				} else {
					curList.push(curFile);
				}
			}
		});

		if (curList.length > 0) {
			this.saveFiles(curList);
		} else {
			this.isLoading = false;
			this.showList = true;
		}
	}

	/**
	 * Save to back-end all files. This is called recursively to
	 * deal with completion of callbacks.
	 *
	 * Init call - saveFiles(curList)
	 * Subsequent/recursive calls - saveFiles(curList, index, files)
	 *
	 * @param curList
	 * @param index
	 * @param files
	 */
	saveFiles(curList, index, files) {
		if (index === undefined) {
			index = 0;
		}
		if (files === undefined) {
			files = [];
		}
		if (curList.length > 0 && index < curList.length) {
			this.getBase64(curList, index, files);
		} else if (index === curList.length) {
			if (curList.length > 1) {
				showToast(succcessMsg, this.uploadSuccessMessagePlural,'success', 'pester');
			} else {
				showToast(succcessMsg, this.uploadSuccessMessageSingular,'success', 'pester');
			}
			this.isLoading = false;
			this.showList = true;
		}
	}

	/**
	 * Parse file input payload for base64 data. Use data to start the chunk by
	 * chunk upload process.
	 *
	 * @param curList
	 * @param index
	 * @param files
	 */
	getBase64(curList, index, files) {
		const file = curList[index];
		const base64 = 'base64,';
		const reader = new FileReader();
		reader.readAsDataURL(file);
		reader.onload = () => {
			let fileContents = reader.result;
			const dataStart = fileContents.indexOf(base64) + base64.length;
			fileContents = fileContents.substring(dataStart);

			// set a default size or startPosition as 0
			const startPosition = 0;

			// calculate the end size or endPosition using Math.min() function which is return the min. value
			const endPosition = Math.min(fileContents.length, startPosition + CHUNK_SIZE);

			this.uploadInChunk(file, fileContents, startPosition, endPosition, files, curList, index, '');
		};
		reader.onerror = function (error) {
			showToast(errorMsg, error,'error', 'dismissable');
		};
	}

	/**
	 * Recursively, chunk by chunk, upload a file. This is to get around SF
	 * payload limits per HTTP request.
	 *
	 * If further files exist, call parent caller 'saveFiles' to iterate
	 * until all outstanding files are uploaded.
	 *
	 * @param file
	 * @param fileContents
	 * @param startPosition
	 * @param endPosition
	 * @param files
	 * @param curList
	 * @param index
	 * @param attachId
	 */
	uploadInChunk(file, fileContents, startPosition, endPosition, files, curList, index, attachId) {
		// This information could be used to create a file upload progress tracker
		// console.log('File Name ===== ' + file.name);
		// console.log('File Size ===== ' + fileContents.length);
		// console.log('File Progress Byte ===== ' + startPosition);
		// console.log('File Progress ===== ' + Math.round(startPosition/fileContents.length*100) + '%');
		const getChunk = fileContents.substring(startPosition, endPosition);
		saveChunk({
			parentId: this.parentId,
			fileName: file.name,
			base64Data: encodeURIComponent(getChunk),
			contentType: file.type,
			fileId: attachId
		})
			.then(response => {
				if (response.success) {
					attachId = response.x7sResults[0].contentID;
					// update the start position with end position
					startPosition = endPosition;
					endPosition = Math.min(fileContents.length, startPosition + CHUNK_SIZE);
					// check if the start position is still less then end postion
					// then call again 'uploadInChunk' method ,
					// else, display alert msg and hide the loading spinner
					if (startPosition < endPosition) {
						this.uploadInChunk(file, fileContents, startPosition, endPosition, files, curList, index, attachId);
					} else {
						// This information could be used to create a file upload progress tracker
						// console.log('File Name ===== ' + file.name);
						// console.log('File Size ===== ' + fileContents.length);
						// console.log('File Progress Byte ===== ' + endPosition);
						// console.log('File Progress ===== ' + '100%');
						index++;
						this.saveFiles(curList, index, files);
					}
				} else {
					showToast(errorMsg, response.messages[0],'error', 'dismissable');
				}
			});
	}

	/**
	 * Call backend 'deleteAttachment' to delete file off of relevant parentId/recordId.
	 * Show spinner in UI during operation.
	 *
	 * @param name
	 */
	deleteFileAttachment(name) {
		this.isLoading = true;
		deleteAttachment({
			fileName: name,
			parentId: this.parentId
		})
			.then( response => {
				if (response.success) {
					showToast(succcessMsg, response.messages[0],'success', 'dismissable');
				} else {
					showToast(errorMsg, response.messages[0],'error', 'dismissable');
				}
				if (this.isLoading) {
					this.isLoading = false;
				}
			});
	}

	/**
	 * Remove file from list in UI. 'valid' value determines which list
	 * to remove the filename from - TRUE = validList, FALSE = invalidList.
	 *
	 * @param name
	 * @param valid
	 */
	removeFileFromList(name, valid) {
		if (valid === 'true') {
			this.validList = this.validList.filter( item => item.name !== name );
		} else {
			this.invalidList = this.invalidList.filter( item => item.name !== name );
		}
		if (this.inForm) {
			this.uploadList = this.uploadList.filter( item => item.name !== name );
		}
	}

	/**
	 * event handler for file deletes
	 *
	 * @param event
	 */
	handleDeleteFile(event) {
		event.preventDefault();

		const name = event.currentTarget.dataset.name;
		const valid = event.currentTarget.dataset.valid;
		this.deleteFileAttachment(name);
		this.removeFileFromList(name, valid);
	}

	/**
	 * event handler for file removal (for invalid files)
	 *
	 * @param event
	 */
	handleRemoveFile(event) {
		event.preventDefault();

		const name = event.currentTarget.dataset.name;
		const valid = event.currentTarget.dataset.valid;
		this.removeFileFromList(name, valid);
	}

	/**
	 * Setting the file list aka finding out which ones will be
	 * uploaded and which ones will be rejected due to an error
	 */
	handleFilesChange(event) {
		event.preventDefault();

		const files = event.target.files;
		if (files.length > 0) {
			this.setFileList(Array.from(files));
		}
	}

	/**
	 * getter - determine if label is hidden or not
	 *
	 * @returns {string}
	 */
	get fileInputVariant() {
		return (this.uploadLabel !== '') ? 'standard' : 'label-hidden';
	}

	/**
	 * getter - format UI description with filesize limits and permitted
	 * extensions embedded in string.
	 *
	 * @returns {string}
	 */
	get formattedDescription() {
		return formatText(this.message, this.fileInfo.maxFileSize, this.fileInfo.prettyExtensions);
	}

	/**
	 * getter - control presentation of valid(file)List, if any exist.
	 *
	 * @returns {boolean}
	 */
	get doHaveValidFiles() {
		return this.validList.length > 0;
	}

	/**
	 * getter - control presentation of invalid(file)List, if any exist.
	 *
	 * @returns {boolean}
	 */
	get doHaveInvalidFiles() {
		return this.invalidList.length > 0;
	}
}