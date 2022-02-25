/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import {LightningElement ,api ,track , wire} from 'lwc';

import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners, fireEvent} from 'c/x7sShrUtils';
import {inLexMode} from 'c/x7sShrUtils';

import getIsObjectCreatable from '@salesforce/apex/x7sEventsListController.isObjectCreatable';

export default class X7sEventsBanner extends NavigationMixin(LightningElement) {

    //Design Properties
    @api listId = 'ID_1';
    @api showTitle = "true";
	@api pluralTitle = "Events";
    @api titleText = "Event";
    @api createButtonURL = "create-events";
    @api createButtonText = "New Event";
    @api showCountBeforeTitle = false;
    @api displaySearch = false;
    @api searchPlaceHolder = "Search";

    //Other Properties
    @track error;
    @api isObjectCreatable = false;
    @api numberOfEvents = 0;

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        registerListener("totalevents", this.updateTotal, this);
        registerListener('selected', this.handleSearch, this);
        getIsObjectCreatable()
        .then(result => {
            this.isObjectCreatable = result;
        })
        .catch(error => {
            this.error = error;
        })
    }

    disconnectedCallback() {
		unregisterAllListeners(this);
    }

    get hideSearch() {
        return !this.displaySearch;
    }
    
    get showButton() {
        return this.isObjectCreatable && this.createButtonURL;
    }

    get hideTitle() {
		return !this.showTitle;
	}

    get eventTitle() {
        let numberOfEvents = parseInt(this.numberOfEvents);
        let titleToShow = (this.showTitle && numberOfEvents === 1) ? this.titleText : this.pluralTitle;
        return this.showCountBeforeTitle ? this.numberOfEvents + ' ' + titleToShow : titleToShow;
    }

    updateTotal(event) {
		if (event.value !== undefined && this.listId === event.id ) {
			this.numberOfEvents = event.value;
		}
    }
    
    handleSearch(event) {
		if (event.value !== undefined && this.listId === event.id) {
            fireEvent(this.pageRef, 'searchstring',
            {
                id: this.listId,
                value: event.value
            });
        }
    }

    navigateToPage() {  
        if (inLexMode()) {
            this[NavigationMixin.Navigate]({
                  type: 'standard__navItemPage',
                  attributes: {
                     apiName: this.createButtonURL
                  }
               });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: this.createButtonURL
                }
            });
        }
    }
}