/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";

import {registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import fetchUsers from "@salesforce/apex/x7sIdeasNewController.fetchUsers";

import idea_label_Search from "@salesforce/label/c.x7sIdeasLabelSearch";

export default class X7sIdeasCustomLookUp extends LightningElement {
	
	@api objectType = "User";
	@api searchLabel = "";
	@api selectedUserId;
	@api isNewIdea;
	@api selectedUser;
	@api isEditing = false;
	@api showCross;
	listOfSearchRecords;
	searchKeyWord = "";
	selectedRecord;
	showDropdown = false;
	disableInput = false;
	error;
	ss_idea_label_Search = idea_label_Search;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		registerListener('customlookselectedrec', this.handleComponentEvent, this);
	}
	
	disconnectedCallback() {
		// unsubscribe from all event
		unregisterAllListeners(this);
	}
	
	renderedCallback() {
		if (this.selectedUser) {
			this.template.querySelector("[data-id=lookupField]").classList.add('slds-hide');
		} else {
			this.template.querySelector("[data-id=searchIcon]").classList.remove('slds-hide');
		}
	}
	
	get objType() {
		return (this.objectType === 'User');
	}
	
	get newOrEditIdea() {
		return (this.isNewIdea || this.isEditing);
	}
	
	get pillLabel() {
		if (this.selectedUser && this.selectedUser.FirstName && this.selectedUser.LastName) {
			return `${this.selectedUser.FirstName}` + ' ' + `${this.selectedUser.LastName}`;
		}
	}
	
	get pillClass() {
		return (this.showCross ? 'pillSize ' : 'pillSize_grow rem-c');
	}
	
	get disableSearch() {
		return (this.disableInput || !this.isNewIdea);
	}
	
	fetchObjectList() {
		
		let searchKeyWord = this.searchKeyWord;
		let _params = {
			inputKeyword: searchKeyWord
		};
		
		let _refObj = this.objectType;
		
		if (_refObj === 'User') {
			fetchUsers(_params)
				.then(result => {
					let _resp = result;
					if (_resp) {
						this.listOfSearchRecords = _resp;
					}
				})
				.catch(error => {
					this.error = error;
				})
		}
	}
	
	clearSelection() {
		
		this.disableInput = false;
		this.selectedUserId = '';
		
		let pillTarget = this.template.querySelector("[data-id=lookup-pill]");
		let lookUpTarget = this.template.querySelector("[data-id=lookupField]");
		
		pillTarget.classList.add('slds-hide');
		pillTarget.classList.remove('slds-show');
		
		lookUpTarget.classList.add('slds-show');
		lookUpTarget.classList.remove('slds-hide');
		
		this.searchKeyWord = '';
		this.listOfSearchRecords = null;
		
		let _refObj = this.objectType;
		
		if (_refObj === 'User') {
			this.selectedUser = '';
		} else if (_refObj === 'Account') {
			this.selectedAccount = '';
		} else if (_refObj === 'Contact') {
			this.selectedContact = '';
		}
	}
	
	blurEvent() {
		this.listOfSearchRecords = null;
		let forClose = this.template.querySelector("[data-id=searchRes]");
		forClose.classList.add('slds-is-close');
		forClose.classList.remove('slds-is-open');
	}
	
	clear() {
		this.clearSelection();
	}
	
	handleSelectRecord(event) {
		if (event.detail === true) {
			this.template.querySelector("[data-id=lookupField]").classList.add('slds-hide');
			this.template.querySelector("[data-id=searchIcon]").classList.add('slds-hide');
		}
	}
	
	focusEvent(event) {
		this.searchKeyWord = event.target.value;
		let mySpinner = this.template.querySelector("[data-id=mySpinner]");
		mySpinner.classList.add('slds-show');
		
		let forOpen = this.template.querySelector("[data-id=searchRes]");
		forOpen.classList.add('slds-is-open');
		forOpen.classList.remove('slds-is-close');
		
		// Get Default 5 Records order by createdDate DESC
		this.fetchObjectList();
	}
	
	handleComponentEvent(event) {
		this.disableInput = true;
		
		// get the selected Account record from the COMPONENT event
		let selectedUser = event.value;
		let _refObj = this.objectType;
		
		if (_refObj === 'User') {
			this.selectedUser = selectedUser;
			this.selectedUserId = selectedUser.Id;
		}
		let forClose = this.template.querySelector("[data-id=lookup-pill]");
		forClose.classList.add('slds-show');
		forClose.classList.remove('slds-hide');
		
		let searchRes = this.template.querySelector("[data-id=searchRes]");
		searchRes.classList.add('slds-is-close');
		searchRes.classList.remove('slds-is-open');
		
		let lookUpTarget = this.template.querySelector("[data-id=lookUpTarget]");
		lookUpTarget.classList.add('slds-hide');
		lookUpTarget.classList.remove('slds-show');
		
	}
}