/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {api, LightningElement, track, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import {custom} from 'c/x7sIdeasBase';
import {fireEvent, inLex, inLexMode,registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import getCommonSettings from '@salesforce/apex/x7sIdeasListController.getCommonSettings';
import labelSubmitNewIdea from "@salesforce/label/c.x7sIdeasBannerSubmitNewIdea";
import label_AriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";

const DELAY = 500;

export default class X7sIdeasBanner extends NavigationMixin(LightningElement) {
	@api zoneName = 'Internal Zone';
	@api listId = 'ID_1';
	@api showTitle = "true";
	@api ideasTitle = "Idea";
	@api pluralTitle = "Ideas";
	@api iconName = 'standard:solution';
	@api displaySearch = "true";
	@api showNumberOfIdeas = "true";
	@api showBottomBorder;
	@api actionButtonText = "Create Ideas";
	@api createIdeasURL = " X7S_Idea_Create_Edit__c";
	@api customClass = ''; // ex: slds-theme_alert-texture
	@api searchPlaceHolder = "Search";
	@api displayVariant = 'None'; // None,Featured,Outline
	
	@track numberOfIdeas = 0;
	@track objectCreate;
	timeoutId;
	labelAriaWrapper = label_AriaWrapper;
	
	@wire(CurrentPageReference) pageRef;
	
	get hideSearch() {
		return !this.displaySearch;
	}
	
	get hideTitle() {
		return !this.showTitle && !this.showNumberOfIdeas;
	}
	
	get ideaBannerTitle() {
		let numberOfIdeas = parseInt(this.numberOfIdeas);
		let titleToShow = (this.showTitle && (numberOfIdeas === 1)) ? this.ideasTitle : this.pluralTitle;
		return this.showNumberOfIdeas ? this.numberOfIdeas + ' ' + titleToShow : titleToShow;
	}
	
	get hideIcon() {
		return !this.iconName;
	}
	
	get bottomBorder() {
		return this.showBottomBorder ? 'slds-p-bottom_small slds-border--bottom' : '';
	}
	
	get componentClass() {
		return `x7s-ideas-banner ${this.customClass}`;
	}
	
	get buttonText() {
		return this.actionButtonText === '' ? labelSubmitNewIdea : this.actionButtonText;
	}
	
	get objectCreatable() {
		return this.objectCreate;
	}
	
	get autoSlds() {
		return inLexMode();
	}
	get variant(){
		return this.displayVariant === 'Featured' ? 'featured' : this.displayVariant === 'Outline' ? 'slds-card' : 'default';
	}
	connectedCallback() {
		registerListener("totalideas", this.updateTotal, this);
		registerListener('selected', this.handleSearch, this);
		
		getCommonSettings({zoneName: this.zoneName})
			.then(result => {
				this.objectCreate = result.canCreateNew;
			})
			.catch(error => {
				this.error = error;
				console.error(error);
			});
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	handleSearch(event) {
		clearTimeout(this.timeoutId);
		this.timeoutId = setTimeout(this.doSearch.bind(this, event), DELAY);
	}
	
	doSearch(target) {
		if (target.value !== undefined && this.listId === target.id) {
			fireEvent(this.pageRef, 'searchstring',
				{
					id: this.listId,
					value: target.value
				});
		}
	}
	
	navigateToPage() {
		let pageRef = inLexMode() ? {
			type: 'standard__webPage',
			attributes: {url: custom.urlParams.lexPrefix + this.createIdeasURL}
		} : {
			type: 'comm__namedPage',
			attributes: {name: this.createIdeasURL}
		};
		
		this[NavigationMixin.Navigate](pageRef);
	}
	
	updateTotal(event) {
		if (event.value !== undefined && this.listId === event.id) {
			this.numberOfIdeas = event.value;
		}
	}
}