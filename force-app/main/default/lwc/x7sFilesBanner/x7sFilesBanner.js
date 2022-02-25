/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference,NavigationMixin} from 'lightning/navigation';
import {fireEvent, registerListener,unregisterAllListeners} from 'c/x7sShrUtils';

import bannerAriaLabel from '@salesforce/label/c.x7sFilesBannerAriaLabel';

export default class X7sFilesBanner extends NavigationMixin(LightningElement) {

	@api searchTitle='true';
    @api searchDescription=false;
	@api searchContent=false;
    @api titleTextSingular='Item';
    @api iconName= "utility:file";
	@api showIcon= 'true';
	@api showTitle= 'true';
	@api displaySearch= 'true';
	@api showNumberOfItems = 'true';
	@api showBottomBorder= false;
	@api customClass = ""; // ex: slds-theme_alert-texture
	@api searchPlaceHolder="Search all Files and Folders";
	@api listId = 'ID_1';
	@api titleTextPlural='Items';
	@api toggleChecked = 'true';
	@api displayVariant = 'None'; // None,Featured,Outline
	delayTimeout = null;
	searchString = '';

    @track numberOfItems = 0;
    @wire(CurrentPageReference) pageRef;
	
	label = {bannerAriaLabel}
	
	connectedCallback() {
		registerListener("folderSearchEvent", this.handleFolderSelect, this);	
        registerListener("totalItems", this.updateTotal, this);
		registerListener("selected", this.handleSearch, this);
		registerListener("clearSearch", this.handleClearSearch, this);
	}

	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
    get hideSearch() {
		return !this.displaySearch;
	}
	
	get hideTitle() {
		return !this.showTitle;
	}
	
	get bannerTitle () {
		let numberOfItems = parseInt(this.numberOfItems);
		let titleToShow = (this.showTitle && (numberOfItems === 1)) ? this.titleTextSingular : this.titleTextPlural;
		return this.showNumberOfItems ? numberOfItems + ' ' + titleToShow : titleToShow;
	}

	get variant() {
		return this.displayVariant === 'Featured' ? 'featured' : this.displayVariant === 'Outline' ? 'slds-card' : 'default';
	}

	get hideIcon() {
		return !this.showIcon;
    }
    
    get bottomBorder() {
		return this.showBottomBorder ? 'slds-p-bottom_small slds-border_bottom' : '';
	}
	
	get componentClass() {
		return `x7s-view-list-banner ${this.customClass}`;
	}

	handleStateChange(event){
        console.log('Toggle',event.target.checked);
		this.toggleChecked = event.target.checked;
	}

	handleFolderSelect(event) {
		if(this.listId === event.id){
			this.searchString = '';
		}
	}

	handleSearch(event) {
		if (this.listId === event.id) {
			let searchContent = false;
			window.clearTimeout(this.delayTimeout);
			this.delayTimeout = setTimeout(() => {
		    searchContent =	this.getSearchToggleChecked() && this.searchContent;
				this.searchString = event.value;
				let searchData = {
					id: this.listId,
					searchString: this.searchString,
					isSearchTitle: this.searchTitle,
					isSearchDescription: this.searchDescription,
					isSearchContent: searchContent
				};
				fireEvent(this.pageRef,'searchItemString',searchData);
			}, 1500);
		}
	}

	getSearchToggleChecked() {
		if (this.toggleChecked) {
			if (this.toggleChecked !== 'false') {
				return true;
			}
		}

		return false;
	}

	updateTotal(event) {
		if (event.value !== undefined && this.listId === event.id ) {
			this.numberOfItems = event.value;
		}
	}
	handleClearSearch(event) {
		if (event.value !== undefined && this.listId === event.id ) {
			this.searchString = event.value;
		}
	}
}