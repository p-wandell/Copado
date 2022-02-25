/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {LightningElement, api, wire} from 'lwc';
import {fireEvent, registerListener, unregisterAllListeners} from "c/x7sShrUtils";
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import FORM_FACTOR from '@salesforce/client/formFactor';

import labelTreeViewHeader from '@salesforce/label/c.x7sFilesListTreeViewHeaderLabel';
import labelTreeViewOpen   from '@salesforce/label/c.x7sFilesTreeViewOpenLabel';
import labelTreeViewClose  from '@salesforce/label/c.x7sFilesTreeViewCloseLabel';
import listAriaLabel       from '@salesforce/label/c.x7sFileslistAriaLabel';
import noResultLabel       from '@salesforce/label/c.x7sFilesListViewNoResultLabel';
import labelNameAtoZ from '@salesforce/label/c.x7sFilesListControlNameAtoZLabel';
import labelNameZtoA from '@salesforce/label/c.x7sFilesListControlNameZtoALabel';
import labelTypeAtoZ from '@salesforce/label/c.x7sFilesListControlTypeAtoZLabel';
import labelTypeZtoA from '@salesforce/label/c.x7sFilesListControlTypeZtoALabel';
import labelFileSizeSmallest from '@salesforce/label/c.x7sFilesListControlFileSizeSmallestLabel';
import labelFileSizeLargest from '@salesforce/label/c.x7sFilesListControlFileSizeLargestLabel';
import labelDateNewest from '@salesforce/label/c.x7sFilesListControlDateNewestLabel';
import labelDateOldest from '@salesforce/label/c.x7sFilesListControlDateOldestLabel';

import getFilesList        from "@salesforce/apex/x7sFilesController.getFilesList";
import getFilesListByRecordId   from "@salesforce/apex/x7sFilesController.getFilesListByRecordId";

export default class X7sFilesList extends NavigationMixin(LightningElement) {

    @api customClass = '';
    @api listId = "ID_1";
    @api tileVariant = 'None';
    @api layout = 'Card';
    @api showTitle = false;
    @api showDescription = false;
    @api pageSize = 9;
    @api descriptionLineCount = 2;
    // TODO: Rename variable to comply with proper camel-case naming conventions.
    @api IconSecWidth = 'Wide';
    @api result;
    @api iconList = [];
    @api cardWidth = '160px';
    @api cardGap = '0rem';
    @api textAlign = 'Center';
    @api showFileType = 'true';
    @api showFileSize = 'true';
    @api showCreatedDate = 'true';
    @api showPreviewAction = 'true';
    @api showTreeView = 'true';
    @api recordId = '';
    @api showBreadcrumbs = 'true';
    @api showDownloadAction = 'true';

    searchString = '';
    isSearchTitle = false;
    isSearchDescription = false;
    isSearchContent = false;
    isLoading = true;
    sortBy='Name (A to Z)';
    itemsCount = 0;
    pageCount = 0;
    pageHasNext = false;
    pageHasPrevious = false;
    pageCurrent = 1;
    layoutClass = 'slds-size_12-of-12 slds-medium-size_3-of-12 slds-large-size_3-of-12';
    listViewClass = 'slds-size_9-of-12';
    FilterData = {};
    filesList = [];
    folderList = [];
    files = [];
    isSplitViewOpen = true;
    hasResults = false;
    breadcrumbs = [];
    workspace = {};
    disableView = false;
    currentFolderId = '';

    @wire(CurrentPageReference) pageRef;

    labels = {labelTreeViewHeader, labelTreeViewOpen, labelTreeViewClose, listAriaLabel, noResultLabel}

    connectedCallback() {

        this.workspace = {
            id: 1,
            name: 'Workspace'
        }

        if (this.recordId) {
            this.getFileListByRecordId();
        } else {
            if (!this.disableView) {
                this.getFileListView();
            }
        }

        registerListener("searchItemString", this.handleSearchString, this);
        registerListener("sortbyevent", this.handleSortBy, this);
        registerListener("cardviewoption", this.cardHandle, this);
        registerListener("listviewoption", this.listHandle, this);
        registerListener("tableviewoption", this.tableHandle, this);
        registerListener("fileFilterEvent", this.filterEventHandle, this);
        registerListener("folderSearchEvent", this.folderSearchHandle, this);
        registerListener("page", this.getPage, this);
        registerListener("pageprevious", this.previousHandle, this);
        registerListener("pagenext", this.nextHandle, this);
        registerListener("resetViewOption", this.resetViewOption, this);
        registerListener("allFolderClick", this.allFolderClickHandle, this);
        registerListener("folderClick", this.handleFolderClick, this);
    }

    renderedCallback() {
        fireEvent(this.pageRef, 'totalItems', {id: this.listId, value: this.itemsCount});
        fireEvent(this.pageRef, 'listdefaultview', {id: this.listId, value: this.layout});
        fireEvent(this.pageRef, 'listpagenumber', {id: this.listId, value: this.pageCurrent});
        fireEvent(this.pageRef, 'listtotalpages', {id: this.listId, value: this.pageCount});
        fireEvent(this.pageRef, 'listsortby', {id: this.listId, value: this.sortBy});
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    toggleSplitView(event) {
        this.isSplitViewOpen = !this.isSplitViewOpen;
    }

    get componentClass() {
		return `x7s-files-list ${this.customClass}`;
	}

    get sidebarClass() {
        return this.isSplitViewOpen ? 'files__sidebar open' : 'files__sidebar closed'
    }

    get splitViewButtonIcon() {
        if(FORM_FACTOR === 'Small') {
            return this.isSplitViewOpen ? 'utility:up' : 'utility:down';
        }
        return this.isSplitViewOpen ? 'utility:left' : 'utility:right';
    }

    get isTableView() {
        return this.layout === 'Table';
    }

    get viewSelectorStyle() {
        return this.layout !== 'List' ? `${this.layoutClass}` : `${this.listViewClass}`;
    }

    get listVariant() {
        return this.layout === 'List' ? 'list' : 'grid';
    }

    get mainClass() {
        return `files__main files__main-${this.layout.toLowerCase()}`;
    }

    get tileVariantStyle () {
        return (this.tileVariant === 'None') ? 'default' : this.tileVariant === 'Featured' ? 'featured' : 'slds-card';
    }

    get showResults() {
        return this.isLoading ? true : this.hasResults && !this.isLoading;
    }
    get showSidebar() {
        return this.showTreeView;
    }

    getFileListByRecordId() {
		this.isLoading = true;
		getFilesListByRecordId({
			parentFolderId: this.currentFolderId,
			pageSize: this.pageSize,
			currentPage: this.pageCurrent,
			searchString: this.searchString,
			isSearchTitle: this.isSearchTitle,
			isSearchDescription: this.isSearchDescription,
			isSearchContent: this.isSearchContent,
			sortString: this.sortBy,
			recordId: this.recordId
		}).then(result => {
			this.isLoading = false;
			if (result.files == null) {
				this.disableView = true;
			} else {
				this.createFileFolderList(result, '');
			}
		});
	}

    getFileListView() {
        this.isLoading = true;
	    if (this.recordId) {
		    this.getFileListByRecordId();
	    } else {
		    getFilesList({
			    parentFolderId: this.currentFolderId,
			    pageSize: this.pageSize,
			    currentPage: this.pageCurrent,
			    searchString: this.searchString,
			    isSearchTitle: this.isSearchTitle,
			    isSearchDescription: this.isSearchDescription,
			    isSearchContent: this.isSearchContent,
			    sortString: this.sortBy,
			    listFilterParams: JSON.stringify(this.FilterData)
		    })
			    .then(result => {
				    this.createFileFolderList(result);
				    this.isLoading = false;
			    }).catch(error => {
			    this.isLoading = false;
			    console.error(error);
		    });
	    }
    }

    createFileFolderList(result) {
        this.result = result;
        this.itemsCount = result.total;
        this.pageCount = result.pageCount;
        this.pageHasNext = result.pageHasNext;
        this.pageHasPrevious = result.pageHasPrevious;
        this.hasResults = result && result.files && result.files.length > 0;
        this.filesList = [];

        this.result.files.forEach(item => {
            this.filesList.push({
                Id: item.Id,
                LinkedEntityId: item.LinkedEntityId,
                Title: item.Title,
                FileType: item.FileType,
                IsFolder: item.IsFolder,
                Description: item.Description,
                VersionId: item.VersionId,
                ContentSize: item.ContentSize,
                ImageUrl: item.ImageUrl,
                CreatedDate: item.CreatedDate,
                iconSetSetting: item.iconSetSetting
            })

            if (item.IsFolder) {
                this.folderList.push({
                    id: item.Id,
                    name: item.Title,
                    description: item.Description,
                    parentId: item.LinkedEntityId,
                    imageURL: item.ImageUrl,
                    CreatedDate: item.CreatedDate,
                    record: {
                        Id: item.Id,
                        Name: item.Title,
                        Description: item.Description,
                        ParentId: item.LinkedEntityId
                    }
                })
            }
        });
        fireEvent(this.pageRef, 'TableViewData', {id: this.listId, value: this.filesList, total: this.itemsCount});
    }

    filterEventHandle(event) {
        if (this.listId === event.id) {
            let filter = event.value;
            this.FilterData = {
            selectedFileTypeValue: filter.selectedFileTypeValue,
            selectedFromDate: filter.selectedFromDate,
            selectedToDate: filter.selectedToDate,
            selectedModFromDate: filter.selectedModFromDate,
            selectedModToDate: filter.selectedModToDate,
            selectedFileSizeValue: filter.selectedFileSizeValue,
            selectedOwnerId: filter.selectedOwnerId,
            selectedModifierId: filter.selectedModifierId,
        }
        if(this.FilterData === {}){
            this.currentFolderId = null;  
        }
        this.pageCurrent = 1;
        this.getFileListView();
        }
    }

    handleSearchString(event) {
        if (this.listId === event.id) {
            this.searchString = event.searchString;
            this.isSearchTitle = event.isSearchTitle;
            this.isSearchDescription = event.isSearchDescription;
            this.isSearchContent = event.isSearchContent;
            this.pageCurrent = 1;
            this.breadcrumbs = [];

            fireEvent(this.pageRef,"folderClick",{id : this.listId,value: '', total: this.itemsCount});

            this.getFileListView();
        }
    }

    folderSearchHandle(event) {
        if (this.listId === event.id) {
            this.pageCurrent = 1;
            this.currentFolderId = event.value;
            this.breadcrumbs = event.breadcrumbs;
            this.searchString = '';
            this.getFileListView();
        }
    }

    allFolderClickHandle(event){
        this.pageCurrent = 1;
        this.currentFolderId = '';
        // Reset breadcrumbs.
        this.breadcrumbs = [];
        this.searchString = '';
        this.getFileListView();
        // Clear tree selection.
        fireEvent(this.pageRef,"folderClick",{id : this.listId,value: ''});
        // Clear search
        fireEvent(this.pageRef,"clearSearch",{id : this.listId,value: ''});
        fireEvent(this.pageRef, 'TableViewData', {id: this.listId, value: this.filesList});
    }

    cardHandle(event) {
        if (this.listId === event.id) {
            this.layout = 'Card';
        }
    }

    listHandle(event) {
        if (this.listId === event.id) {
            this.layout = 'List';
        }
    }

    tableHandle(event) {
        if (this.listId === event.id) {
            this.layout = 'Table';
        }
    }

    previousHandle(event) {
        if (this.listId === event.id) {
            let pageNumber = this.pageCurrent;
            let previousFilter = this.result;
            previousFilter.pageCurrent = pageNumber - 1;
            this.pageCurrent = previousFilter.pageCurrent;
            this.getFileListView();
        }

        fireEvent(this.pageRef, 'hasprevious', {id: this.listId, value: this.pageHasPrevious});
    }

    nextHandle(event) {
        if (this.listId === event.id) {
            let pageNumber = this.pageCurrent;
            let nextFilter = this.result;
            nextFilter.pageCurrent = pageNumber + 1;
            this.pageCurrent = nextFilter.pageCurrent;
            this.getFileListView();
        }

        fireEvent(this.pageRef, 'hasnext', {id: this.listId, value: this.pageHasNext});
    }

    getPage(event) {
        if (this.listId === event.id) {
            this.pageCurrent = event.detail;
            this.getFileListView();
        }
    }

    resetViewOption(event) {
        if (this.listId === event.id) {
            this.layout = event.value;
        }
    }

    handleSortBy(event) {
        if (this.listId === event.id) {
            let defaultSort = event.value;
            if(defaultSort === labelNameAtoZ){this.sortBy = 'A to Z Name' }
		    else if(defaultSort === labelNameZtoA){this.sortBy = 'Z to A Name' }
		    else if(defaultSort === labelTypeAtoZ){this.sortBy = 'A to Z Type' }
		    else if(defaultSort === labelTypeZtoA){this.sortBy = 'Z to A Type' }
		    else if(defaultSort === labelFileSizeSmallest){this.sortBy = 'Low To High Size' }
		    else if(defaultSort === labelFileSizeLargest){this.sortBy = 'High to Low Size' }
		    else if(defaultSort === labelDateNewest){this.sortBy = 'High to Low Date' }
		    else if(defaultSort === labelDateOldest){this.sortBy = 'Low To High Date' }
            this.pageCurrent = 1;
            this.getFileListView();
        }
    }

    handleFolderClick(event) {
        if (this.listId === event.id) {
            this.pageCurrent = 1;
            this.currentFolderId = event.value;
            this.breadcrumbs = event.breadcrumbs;
            this.getFileListView();
        }
    }
}