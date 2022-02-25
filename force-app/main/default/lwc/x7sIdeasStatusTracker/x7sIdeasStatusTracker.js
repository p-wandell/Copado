/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';

import {updateIdeaValues} from 'c/x7sIdeasBase';
import {registerListener, unregisterAllListeners,inLexMode} from 'c/x7sShrUtils';
import getIdeaStatusValues from '@salesforce/apex/x7sIdeasViewController.getIdeaStatusValues';

export default class X7sIdeasStatusTracker extends LightningElement {
	
	@api recordId;
	@api listId = "ID_1";
	@api title = "";
	@api statusType = "path";
	@api statusAllowed = "";
	@api customClass = "";
	@api variant = "None";
	
	idea;
	statusSet;
	currentStep = "";
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.getStatusSet();
		registerListener("getideainfo", this.handleIdeaInfo, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get showStatusTracker() {
		return this.idea && this.idea.Id;
	}
	get displayVariant(){
		return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}
	get autoSlds() {
		return inLexMode();
	}
	getStatusSet() {
		let statusValues = this.statusAllowed;
		
		if (statusValues && statusValues.trim() !== '')
			this.statusSet = statusValues.split(',');
		else {
			getIdeaStatusValues()
				.then(result => {
					this.statusSet = result;
				})
				.catch(error => {
					console.error("Error occurred getting Idea Status Values:" + error);
				})
		}
	}
	
	handleIdeaInfo(event) {
		if (this.listId === event.id) {
			let ideasListWrapper = event.value;
			let idea = updateIdeaValues(
				ideasListWrapper.ideaList[0],
				ideasListWrapper.topicNameToId,
				ideasListWrapper.sitePath,
				'', '', this.pageRef);
			this.idea = idea;
			this.currentStep = idea.Status;
		}
	}
}