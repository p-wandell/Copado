/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';

import {custom, getRecordIdFromURL} from 'c/x7sIdeasBase';
import getExtensionId from '@salesforce/apex/x7sIdeasFeedPublishController.getExtensionId';
import getAllRelatedFilesDetails from '@salesforce/apex/x7sIdeasFeedPublishController.getAllRelatedFilesDetails';

import labelFileUploader from "@salesforce/label/c.x7sIdeasFilesLabelFileUploader";

export default class X7sIdeasFiles extends LightningElement {
	
	@api recordId;
	@api idea;
	@api title = "";
	@api accept = ".pdf,.png";
	@api showFileUploader = false;
	@api showFileViewer = false;
	
	isParentCalled = false;
	visibility = "AllUsers";
	multiple = true;
	disabled = false;
	files;
	
	labels = {
		labelFileUploader,
	}
	
	connectedCallback() {
		if (!this.recordId) {
			this.recordId = getRecordIdFromURL();
		}
		
		if (this.recordId) {
			this.getExtension();
		}
	}
	
	get showTitle() {
		return this.title !== "";
	}
	
	get showFilesViewer() {
		return this.showFileViewer && (this.files && this.files.length > 0);
	}
	
	get titleText() {
		return this.files && this.files.length > 0 ? `${this.title}(${this.files.length})` : `${this.title}(0)`;
	}
	
	getExtension() {
		getExtensionId({
			ideaId: this.recordId
		}).then(result => {
			this.idea = result;
			this.getFileIds();
		}).catch(error => {
			console.error("Error occurred getting extension id:" + error);
		})
	}
	
	getFileIds() {
		getAllRelatedFilesDetails({
			ideaId: this.recordId,
			isExtension: this.isParentCalled,
			visibility: this.visibility,
			maxLength: custom.MAX_RELATED_FILES
		}).then(result => {
			if (result) {
				let files = result;
				this.isParentCalled = true;
				
				files.forEach(function (file, index) {
					file.imageSource = '/sfc/servlet.shepherd/document/download/' + file.Id;
					
					switch (file.FileExtension) {
						
						case 'jpg':
						case 'png':
						case 'gif':
							file.iconName = 'doctype:image';
							break;
						
						case 'xlsx':
						case 'xlsm':
						case 'xltx':
						case 'xltm':
						case 'xls':
							file.iconName = 'doctype:excel';
							break;
						
						case 'pdf':
							file.iconName = 'doctype:pdf';
							break;
						
						case 'pptx':
						case 'pptm':
						case 'potx':
						case 'potm':
						case 'ppam':
						case 'ppsx':
						case 'ppsm':
						case 'sldx':
						case 'sldm':
						case 'ppt':
							file.iconName = 'doctype:ppt';
							break;
						
						case 'txt':
							file.iconName = 'doctype:txt';
							break;
						
						case 'docx':
						case 'docm':
						case 'dotx':
						case 'dotm':
						case 'doc':
							file.iconName = 'doctype:word';
							break;
						
						case 'zip':
							file.iconName = 'doctype:zip';
							break;
						
						case 'pages':
							file.iconName = 'doctype:pages';
							break;
						
						case 'key':
						case 'keynote':
							file.iconName = 'doctype:keynote';
							break;
						
						default:
							file.iconName = 'doctype:unknown';
					}
				}.bind(this));
				
				this.files = files;
			}
		}).catch(error => {
			console.error("Error occurred getting all related file ids:" + error);
		})
	}
	
	handleUploadFinished() {
		this.isParentCalled = false;
		this.getFileIds();
	}
	
	handlePreview(event) {
		let id = event.currentTarget.dataset.id;
		eval("$A.get('e.lightning:openFiles').fire({recordIds: ['" + id + "']});");
	}
}