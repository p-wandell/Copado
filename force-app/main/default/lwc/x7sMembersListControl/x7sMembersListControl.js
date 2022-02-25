/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import { LightningElement,api,wire } from 'lwc';
import {registerListener, unregisterAllListeners,fireEvent} from 'c/x7sShrUtils';
import {CurrentPageReference} from "lightning/navigation";

import labelSortByFirstName from '@salesforce/label/c.x7sMembersLabelSortByFirstName';
import labelSortByLastName from '@salesforce/label/c.x7sMembersLabelSortByLastName';
import labelSortByNewest from '@salesforce/label/c.x7sMembersLabelSortByNewest';
import labelSortByOldest from '@salesforce/label/c.x7sMembersLabelSortByOldest';

export default class X7sMembersListControl extends LightningElement {

    @api listId = 'ID_1';
	@api customClass='';
	
	@api showViewSelector="true";
	@api showSort="true";
	@api sortOptions;
	@api sortVariant = 'standard';
	@api showPagination="true";
    @api defaultSort = 'Sort by First Name';
    
    hasNext = false;
	hasPrevious = false;
	
	@wire(CurrentPageReference) pageRef;

    connectedCallback() {
		registerListener('listhasnext',     this.handleHasNext,     this);
		registerListener('listhasprevious', this.handleHasPrevious, this);
	}

	renderedCallback(){
		fireEvent(this.pageRef, 'defaultsortbyevent', {id: this.listId, value: this.defaultSort});
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
            { label: labelSortByFirstName,  value: 'Sort by First Name' },
            { label: labelSortByLastName,   value: 'Sort by Last Name' },
            { label: labelSortByNewest,     value: 'Date Joined Newest' },
            { label: labelSortByOldest,     value: 'Date Joined Oldest' }
        ];
    }
    
    handleHasNext (event) {
		if (event.id === this.listId) {
			this.hasNext = event.value;
		}
	}
	
	handleHasPrevious (event) {
		if (event.id === this.listId) {
			this.hasPrevious = event.value;
		}
	}
}