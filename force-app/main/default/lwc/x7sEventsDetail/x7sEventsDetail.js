/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import {LightningElement, api, wire} from 'lwc';

import {fireEvent} from 'c/x7sShrUtils';
import {CurrentPageReference} from 'lightning/navigation';
import {custom, constants} from 'c/x7sEventsBase';

import getEventRecord from '@salesforce/apex/x7sEventsListController.getEventRecord';
import getSitePrefix from '@salesforce/apex/x7sEventsListController.getSitePrefix';

import labelNotAvailable from '@salesforce/label/c.x7sEventsDetailItemNotAvailable';

export default class X7sEventsDetail extends LightningElement {
	
	@api imageHeight = "400px";
	@api layoutVariant = "featured";
	@api customClass = "";
	@api listId = "ID_1";
	@api recordId;
	@api layout = 'vertical';
	
	@api showEventRecord = false;
	@api showEventType = false;
	@api customLabel1 = "";
	@api customField1 = "";
	@api customLabel2 = "";
	@api customField2 = "";
	@api customLabel3 = "";
	@api customField3 = "";
	
	customFieldValue1;
	customFieldValue2;
	customFieldValue3;
	
	sitePath;
	sitePrefix;
	eventType;
	eventsListWrapper;
	attachmentPath;
	event;
	hideImage = true;
	eventDetails;
	imageURL;
	
	labels = {
		labelNotAvailable
	}
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.showEventRecord = true;
		this.getSitePrefix();
		this.getEvent();
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'geteventinfo', {id: this.listId, value: this.eventsListWrapper});
	}
	
	getSitePrefix() {
		getSitePrefix()
			.then(result => {
				this.sitePath = result;
				let position = this.sitePath.lastIndexOf('/s');
				let sitePrefix = this.sitePath.substring(0, position);
				this.sitePrefix = sitePrefix;
				this.attachmentPath = sitePrefix + custom.ATTACHMENT_PATH;
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	getEvent() {
		getEventRecord({
			eventRecordId: this.recordId,
			customFields: this.getCustomFields()
		})
			.then(result => {
				let eventsListWrapper = result;
				
				if (eventsListWrapper.objEventList.length) {
					this.showEventRecord = true;
					
					//Get Image URL
					let event = eventsListWrapper.objEventList[0];
					
					//Get Event Details
					this.eventDetails = event.Details__c;
					
					if (eventsListWrapper.isGuestUser ? false : !!eventsListWrapper.languageEnabled) {
						if (event.Language__c !== eventsListWrapper.userLanguage) {
							this.eventDetails = event.X7S_Event_Translation__r[0].Details__c;
						}
					}
					
					//Get Event Type
					if (this.showEventType) {
						if (event.Event_Type__c) {
							this.eventType = event.Event_Type__c;
						}
					}
					
					//Get Custom fields
					this.setCustomFields(eventsListWrapper.objEventList, 0);
					if (this.customField1 && this.customField1.length > 0) {
						this.customField1Value = event.customField1;
					}

					//Get Image URL
					let attachments = event.Attachments;
					let imageURL = eventsListWrapper.eventIdtoimageURLMap[event.Id];
					if(event.Image_Type__c === constants.imageTypes.NONE) {
						this.hideImage = true;
					} else {
						if(imageURL != undefined) {
							this.hideImage = false;
							this.imageURL  = imageURL;
							
						} else if (attachments && attachments.length) {
							let attachId = event.Attachments[0].Id;
							if (attachId && attachId.length) {
								this.hideImage = false;
								this.imageURL = this.attachmentPath + attachId;
							}
						}
					}
					this.eventsListWrapper = eventsListWrapper;
				} else {
					this.showEventRecord = false;
				}
			})
			.catch(error => {
				console.error("Error occurred while getting event list:" + JSON.stringify(error));
			})
		
	}
	
	getCustomFields() {
		let customFields = '';
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			if (customField && customField.length) {
				customFields += customField + ',';
			}
		}
		return customFields;
	}
	
	setCustomFields(objEventList, index) {
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			
			if (customField && customField.length) {
				let fieldSet = true;
				let fieldParts = customField.split('.');
				let fieldValue = objEventList[index];
				
				for (let part = 0; part < fieldParts.length; part++) {
					if (fieldValue[fieldParts[part]]) {
						fieldValue = fieldValue[fieldParts[part]];
					} else {
						fieldSet = false;
						break;
					}
				}
				this[`customFieldValue${pos}`] = fieldSet ? fieldValue : '';
			}
		}
	}
}