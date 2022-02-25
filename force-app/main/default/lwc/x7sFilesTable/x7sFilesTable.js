/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {LightningElement, api, wire} from 'lwc';
import {registerListener,fireEvent, inLexMode, unregisterAllListeners} from "c/x7sShrUtils";
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import {formattedFileSize} from 'c/x7sFilesBase';

import labelTitle from '@salesforce/label/c.x7sFilesTableTitleLabel';
import labelDescription from '@salesforce/label/c.x7sFilesTableDescriptionLabel';
import labelType from '@salesforce/label/c.x7sFilesTableTypeLabel';
import labelSize from '@salesforce/label/c.x7sFilesTableSizeLabel';
import labelCreatedDate from '@salesforce/label/c.x7sFilesTableCreatedDateLabel';
import labelPreview from '@salesforce/label/c.x7sFilesTablePreviewLabel';
import tableAriaLabel from '@salesforce/label/c.x7sFilesTableViewAriaLabel';
import getFolders from "@salesforce/apex/x7sFilesController.getFolders";

export default class X7sFilesTable extends NavigationMixin(LightningElement) {
    @api listId = '';
    @api result = '';
    @api showDescription = 'true';
    @api showTitle = 'true';
    @api customClass = '';
    @api variant = 'None';
    @api showFileType = 'true';
    @api showFileSize = 'true';
    @api showCreatedDate = 'true';
    @api recordId = '';
    @api showViewDetailsAction = false;
	@api showDownloadAction = false;

    columns = [];
    data = [];
    actions = [];
    totalItems = 0;
    files = [];
    parentNodeList = [];
	childNodeList = [];
	treeResult = '';
	selectedItemValue = '';

    @wire(CurrentPageReference) pageRef;

    label = {tableAriaLabel}

    connectedCallback() {
        this.files = this.result.files;
        this.totalItems = this.result.total;
        this.getTableData();

        getFolders({recordId: this.recordId})
        .then(result => {
            this.treeResult = result;
            this.getTreeData(this.treeResult);
            this.getTree(this.parentNodeList, this.childNodeList);
        });

        registerListener("TableViewData", this.dataHandle, this);
        registerListener("folderClick", this.handleFolderSelected, this);

    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    renderedCallback() {
        if(this.template.querySelector('lightning-datatable') != null){
            const style = document.createElement('style');
            style.innerText = `c-x7s-files-table .slds-button {
                max-width: 100%;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }`;

            this.template.querySelector('lightning-datatable').appendChild(style);  
        }
    }

    get componentClass() {
        return `x7s-files-table ${this.customClass}`;
    }

    get hasItems() {
        return this.totalItems > 0;
    }

    get viewVariant() {
        return (this.variant === 'None') ? 'default' : 'featured';
    }

    getTableData() {
        let currentData = [];
        let baseUrl = 'https://' + location.host + '/';
        if (this.totalItems > 0) {
            this.files.forEach((row) => {
                let rowData = {};
                this.showDescription && row.Description ? rowData.description = row.Description : '';
                row.FileType ? rowData.FileType = row.FileType : rowData.FileType = 'Folder';
                row.ContentSize ? rowData.fileSize = formattedFileSize(row.ContentSize) : '';
                row.CreatedDate ? rowData.createdDate = row.CreatedDate : '';
                rowData.IsFolder = row.IsFolder;
                if (this.showTitle) {
                    if (row.Id) {
                        rowData.Title = row.Title;
                        rowData.TitleUrl = baseUrl + row.Id;
                        rowData.Id = row.Id;
                    }
                    if (row.IsFolder) {
                        console.log('item id', row.Id);
                    }
                }
                currentData.push(rowData);
                this.data = currentData;
            });
            this.showTitle ? this.columns.push({
                label: labelTitle,
                type: 'button',
                cellAttributes:{alignment: 'left'},
                typeAttributes: {label: {fieldName: 'Title'}, name: 'viewRecord', disabled: false, variant:'base', class:"linkstyle"},
                hideDefaultActions: true
            }) : '';
            this.showDescription ? this.columns.push({
                label: labelDescription,
                cellAttributes:{alignment: 'left'},
                fieldName: 'description',
                type: 'text'
            }) : '';
            this.showFileType ? this.columns.push({label: labelType, fieldName: 'FileType', type: 'text', cellAttributes:{alignment: 'left'}}) : '';
            this.showFileSize ? this.columns.push({label: labelSize, fieldName: 'fileSize', type: 'text',cellAttributes:{alignment: 'left'}}) : '';
            this.showCreatedDate ? this.columns.push({
                label: labelCreatedDate,
                fieldName: 'createdDate',
                cellAttributes:{alignment: 'left'},
                type: 'date'
            }) : '';
            this.columns.push({type: 'action', typeAttributes: {rowActions: this.getRowActions.bind(this)}});
        }
    }

    getRowActions(row, doneCallback) {
        let tableAction = [];
            this.showViewDetailsAction ? tableAction.push({
            label: 'View Details',
            name: 'viewDetails',
        }):'';
        if(!row.IsFolder){
            this.showDownloadAction ? tableAction.push({
                label: 'Download',
                name: 'Download',
            }) : '';
        }
        doneCallback(tableAction);
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

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {
            case 'viewDetails':
                this.viewDetails(row);
                break;
            case 'Download':
                this.downloadFile(row);
                break;
            case 'viewRecord':
                this.handleNameClick(row);
                break;
            case 'titleStyle':
                "table-item_max-lines"
                break;
            default:
        }
    }

    viewDetails(row) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                "recordId": row.Id,
                "actionName": "view"
            },
        }).then(url => {
            window.open(url, "_blank");
        });
    }

    downloadFile(row) {
        let baseUrl = 'https://' + location.host + '/sfc/servlet.shepherd/document/download/';
		let URL = baseUrl + row.Id;
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: URL
			},
		});
    }

    handleNameClick(row) {
        if(row.IsFolder) {
            fireEvent(this.pageRef, "folderClick", {id: this.listId, value:row.Id});
        } else {
            this.previewRow(row);
        }
    }

    previewRow(row) {
        let URL = row.TitleUrl;
        let id = URL.substring(URL.lastIndexOf('/') + 1);
        eval("$A.get('e.lightning:openFiles').fire({recordIds: ['" + id + "']});");
    }

    dataHandle(event) {
        if (this.listId === event.id) {
            this.data = [];
            this.columns = [];
            this.files = event.value;
            this.totalItems = event.total;
            this.getTableData();
        }
    }

    handleFolderSelected(event) {
		if (this.listId === event.id) {
			this.selectedItemValue = event.value;
			this.handleFolders();
		}
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

    get isSldsCard() {
        return inLexMode();
    }

}