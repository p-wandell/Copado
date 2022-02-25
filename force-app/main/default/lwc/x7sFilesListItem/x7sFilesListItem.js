/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {api, LightningElement, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {formattedFileSize} from 'c/x7sFilesBase';

import labelPreview from '@salesforce/label/c.x7sFilesTablePreviewLabel';
import labelViewDetails from '@salesforce/label/c.x7sFilesListTableViewDetailsLabel';
import labelDownload from '@salesforce/label/c.x7sFilesListDownloadLabel';
import labelAdded from '@salesforce/label/c.x7sFilesListItemLabelAdded';

import {classSet, fireEvent, registerListener, unregisterAllListeners} from "c/x7sShrUtils";
import getFolders from "@salesforce/apex/x7sFilesController.getFolders";

export default class X7sFilesListItem extends NavigationMixin(LightningElement) {
	@api item;
	@api networkPrefix = '';
	@api layout = 'tile'; // tile, list
	@api iconList = [];
	@api showViewDetailsAction = false;
	@api listId = 'ID_1';
	@api showFileType = false;
	@api showFileSize = false;
	@api showCreatedDate = false;
	@api showTitle = false;
	@api showDescription = false;
	@api descriptionLines = 2;
    @api recordId;
	@api showDownloadAction = false;
	
	url;
	parentNodeList = [];
	childNodeList = [];
	treeResult = '';
	selectedItemValue = '';
	
	@wire(CurrentPageReference) pageRef;
	labels = {labelPreview, labelViewDetails, labelDownload, labelAdded}
	
	connectedCallback() {
			
		this.contentRef = {
			type: 'comm__recordPage',
			attributes: {
				recordId: this.item.Id,
				actionName: 'home'
			}
		};
		this[NavigationMixin.GenerateUrl](this.contentRef)
			.then(url => this.url = url);
		
		getFolders({recordId: this.recordId})
			.then(result => {
				this.treeResult = result;
				this.getTreeData(this.treeResult);
				this.getTree(this.parentNodeList, this.childNodeList);
			});
		
		registerListener("folderClick", this.handleFolderSelected, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	handleFolderClick() {
		fireEvent(this.pageRef, "folderClick", {id: this.listId, value: this.item.Id});
		this.handleFolders();
	}
	
	handleFolders() {
		let foundItem = this.childNodeList.filter(item => {
			return item.Id === this.selectedItemValue
		});
		
		if (foundItem.length === 0) {
			foundItem = this.parentNodeList.filter(item => {
				return item.Id === this.selectedItemValue
			});
		}

		fireEvent(this.pageRef, "folderSearchEvent", {
			id: this.listId,
			value: this.selectedItemValue,
			breadcrumbs: foundItem[0].breadcrumbs
		});
	}
	
	handleThumbClick() {
		eval("$A.get('e.lightning:openFiles').fire({recordIds: ['" + this.item.Id + "']});");
	}
	
	getTreeData(result) {
		if (result) {
			result.files.forEach(element => {
				if (element.ParentId) {
					this.childNodeList.push(
						{
							Id: element.Id,
							parentId: element.ParentId,
							label: element.Title,
							breadcrumbs: element.breadcrumbs
						});
				} else {
					this.parentNodeList.push(
						{
							Id: element.Id,
							label: element.Title,
							breadcrumbs: element.breadcrumbs
						});
				}
			});
		} else {
			console.error('No Result found for the tree.');
		}
	}
	
	getTree(parentNodeList, childNodeList) {
		let parent = [];
		for (let index in parentNodeList) {
			if (index < parentNodeList.length) {
				let treeData = {};
				treeData.items = this.getChildNode(parentNodeList[index].Id, childNodeList);
				
				treeData.label = parentNodeList[index].label;
				treeData.name = parentNodeList[index].Id;
				treeData.expanded = false;
				parent.push(treeData);
			}
		}
		this.finalTree = parent;
	}
	
	getChildNode(strId, childNodeList) {
		let child = [];
		for (let index in childNodeList) {
			if (childNodeList[index].parentId === strId) {
				let childData = {};
				childData.label = childNodeList[index].label;
				childData.name = childNodeList[index].Id;
				childData.breadcrumbs = childNodeList[index].breadcrumbs;
				childData.expanded = false;
				childData.items = this.getChildNode(childNodeList[index].Id, childNodeList);
				if (childData.items.length === 0) {
					this.count = this.count + 1;
				}
				child.push(childData);
			}
		}
		return child;
	}
	
	get descriptionStyle() {
		return this.descriptionLines && this.descriptionLines !== '0' ? `-webkit-line-clamp: ${this.descriptionLines};` : '';
	}
	
	get descriptionClass() {
		return classSet('files-item__description')
			.add({
				'files-item_max-lines': this.descriptionLines && this.descriptionLines !== '0'
			})
			.toString();
	}
	
	get isShowTypeAndSize() {
		return this.showFileSize && this.showFileType;
	}
	
	get showItem() {
		return this.item && this.item.Title && this.item.Title !== '';
	}
	
	get showThumb() {
		return this.item && this.versionId;
	}
	
	get isFolder() {
		return this.item.IsFolder && this.showItem;
	}
	get isFile() {
		return !this.item.IsFolder && this.showItem;
	}
	
	get itemClass() {
		return `files-item files-item_${this.layout.toLowerCase()} ${this.showFileThumb ? 'files-item_show-thumb' : ''}`;
	}
	
	get itemIconName() {
		let iconName = '';
		if (this.item.IsFolder) {
			iconName = 'utility:open_folder';
		} else {
			iconName = 'utility:file';
		}
		return iconName;
	}
	
	get thumbSize() {
		return this.layout === 'tile' ? 'THUMB720BY480' : 'THUMB120BY90';
	}
	
	get thumbUrl() {
		const prefix = (this.networkPrefix) ? '/' + this.networkPrefix : '';
		return `${prefix}/sfc/servlet.shepherd/version/renditionDownload?rendition=${this.thumbSize}&versionId=${this.versionId}&operationContext=CHATTER`;
	}
	
	get thumbStyle() {
		return `background-image: url(${this.thumbUrl});`;
	}
	
	get versionId() {
		if (this.item && this.item.VersionId) {
			return this.item.VersionId;
		}
		return '';
	}
	
	get showFileThumb() {
		if (this.item.iconSetSetting && this.item.iconSetSetting.fileIconList[0]) {
		    return this.item.iconSetSetting.fileIconList[0].showPreview;
		}
		else{
			return false;
		}
	}

	get isImage() {
		if (this.item.iconSetSetting  && this.item.iconSetSetting.fileIconList) {
			for (let item in this.item.iconSetSetting.fileIconList) {
				if (this.item.iconSetSetting.fileIconList[item].fileType === this.item.FileType.toLowerCase()) {
					let fileItem = this.item.iconSetSetting.fileIconList[item].iconName;
					return fileItem.startsWith("http", 0) || (!fileItem.includes(':'))? true : false;
				}
			}
		}
	}

	get fileImage() {
		if (this.item.iconSetSetting  && this.item.iconSetSetting.fileIconList) {
			for (let item in this.item.iconSetSetting.fileIconList) {
				if (this.item.iconSetSetting.fileIconList[item].fileType === this.item.FileType.toLowerCase()) {
					let fileItem = this.item.iconSetSetting.fileIconList[item].iconName;
					return fileItem.startsWith("http", 0) ? `background-image: url(${fileItem});`: `background-image: url("/resource/${fileItem}");`;
				}
			}	
		}
	}
	
	get fileIcon() {
		let iconName = '';
		if (this.item.iconSetSetting  && this.item.iconSetSetting.fileIconList) {		
		for (let item in this.item.iconSetSetting.fileIconList) {
			if (this.item.iconSetSetting.fileIconList[item].fileType === this.item.FileType.toLowerCase()) {
				iconName = this.item.iconSetSetting.fileIconList[item].iconName;
			}
		}
	}
	if (!iconName) { iconName = 'utility:file'; }
	return iconName;
    }
	
	get fileSize() {
		return (formattedFileSize(this.item.ContentSize));
	}
	
	get fileCreatedDate() {
		return this.item.CreatedDate;
	}
	
	previewHandler() {
		eval("$A.get('e.lightning:openFiles').fire({recordIds: ['" + this.item.Id + "']});");
	}
	
	handleItemClick() {
		this[NavigationMixin.GenerateUrl]({
			type: 'standard__recordPage',
			attributes: {
				"recordId": this.item.Id,
				"objectApiName": "X7S_File_Folder__c",
				"actionName": "view"
			},
		}).then(url => {
			window.open(url, "_blank");
		});
	}
	
	downloadHandler() {
		let baseUrl = 'https://' + location.host + '/sfc/servlet.shepherd/document/download/';
		let URL = baseUrl + this.item.Id;
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: URL
			},
		});
	}
	
	handleFolderSelected(event) {
		if (this.listId === event.id) {
			this.selectedItemValue = event.value;
			this.handleFolders();
		}
	}
}