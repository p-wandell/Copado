/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
import { LightningElement,api,wire } from 'lwc';
import {registerListener, unregisterAllListeners,fireEvent} from 'c/x7sShrUtils';
import {CurrentPageReference} from "lightning/navigation";

import x7sNewsOldestFirst from '@salesforce/label/c.x7sNewsOldestFirst';
import x7sNewsMostRecent from '@salesforce/label/c.x7sNewsMostRecent';
import x7sNewsAriaLabelForNewsListControlLandmark from '@salesforce/label/c.x7sNewsAriaLabelForNewsListControlLandmark';

export default class X7sNewsListControl extends LightningElement {

    @api listId = 'ID_1';
	@api customClass='';
	
	@api showViewSelector="true";
	@api showSort="true";
	@api sortOptions;
	@api sortVariant = 'standard';
	@api showPagination="true";
    @api defaultSort = 'Most Recent';

	ariaLabelForNewsListControlLandmark = x7sNewsAriaLabelForNewsListControlLandmark;
	
    @wire(CurrentPageReference) pageRef;
    
	renderedCallback(){
		fireEvent(this.pageRef, 'sortbyevent', {id: this.listId, value: this.defaultSort});
	}
	disconnectedCallback() {
		// unsubscribe from all event
		unregisterAllListeners(this);
    }
    
    get hidePagination() {
		return !this.showPagination;
	}
	get hideSort() {
		return !this.showSort;
	}
	get hideViewSelector() {
		return !this.showViewSelector;
    }
    
    get sortBy() {
		return [
			{label: x7sNewsMostRecent, value: "Most Recent"},
			{label: x7sNewsOldestFirst, value: "Oldest First"}
		];
    }
}