/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
import { LightningElement,api,track,wire } from 'lwc';
import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import {inLexMode, fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

import get_isObjectCreatable from '@salesforce/apex/x7sNewsController.isObjectCreatable';

import x7sNewsNewNewsLabel from "@salesforce/label/c.x7sNewsNewNewsLabel";

export default class X7sNewsBanner extends NavigationMixin(LightningElement) {

    @api listId = 'ID_1';
	@api iconName;
	@api newsTitle;
	@api displaySearch;
	@api showNumberOfNews;
	@api showBottomBorder;
    @api actionButtonText;
    @api createNewsURL;
	@api customClass = ''; // ex: slds-theme_alert-texture
    @api searchPlaceHolder;

    @track numberOfNews = 0;
    @track objectCreate;
    
    @wire(CurrentPageReference) pageRef;
	
	connectedCallback() {

		registerListener("totalnews", this.updateTotal, this);
        registerListener('selected', this.handleSearch, this);
        
        get_isObjectCreatable()
			.then(result => {
				this.objectCreate = result;
			})
			.catch(error => {
				this.error = error;
			});
    }
    
    disconnectedCallback() {
		unregisterAllListeners(this);
	}

	get landmarkRoleForOuterDiv() {
		return this.displaySearch ? 'search' : 'banner';
	}
	
	get hideSearch() {
		return !this.displaySearch;
	}
	
	get hideTitle() {
		return !this.newsTitle && !this.showNumberOfNews;
	}
	
	get newsBannerTitle () {
		return this.showNumberOfNews ? this.numberOfNews + ' ' + this.newsTitle : this.newsTitle;
	}
	
	get hideIcon() {
		return !this.iconName;
	}
	
	get bottomBorder() {
		return this.showBottomBorder ? 'slds-p-bottom_small slds-border--bottom' : '';
	}
	
	get componentClass() {
		return `x7s-news-banner ${this.customClass}`;
	}
	
	get buttonText() {
		return this.actionButtonText === '' ? x7sNewsNewNewsLabel : this.actionButtonText;
    }
    
    get objectCreatable() {
		return this.objectCreate;
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
						apiName: this.createNewsURL
					}
				});
		} else {
			this[NavigationMixin.Navigate]({
				type: 'comm__namedPage',
				attributes: {
					name: this.createNewsURL
				}
			});
		}
    }

    updateTotal(event) {
		if (event.value !== undefined && this.listId === event.id ) {
			this.numberOfNews = event.value;
		}
	}
}