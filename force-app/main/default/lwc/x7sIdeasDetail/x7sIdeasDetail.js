/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';

import {fireEvent,inLexMode} from 'c/x7sShrUtils';
import {getRecordIdFromURL} from 'c/x7sIdeasBase';

import getCommonSettings from '@salesforce/apex/x7sIdeasViewController.getCommonSettings';
import getIdeaRecord from '@salesforce/apex/x7sIdeasViewController.getIdeaRecord';
import label_AriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";

export default class X7sIdeasDetail extends LightningElement {
	@api zoneName = 'Internal Zone';
	@api imageHeight = "400px";
	@api layoutVariant = "Featured";
	@api customClass = "";
	@api listId = "ID_1";
	@api recordId = "";
	@api layout = 'Card';
	@api customFieldSetName;
	@api showCustomFields = "true";
	@api hideEmptyCustomFields = "true";
	
	customFields = [];
	settings;
	sitePrefix;
	sitePath;
	zoneId;
	authenticatedOnly = false;
	idea;
	ideaDesc;
	ideaImageURL = "/servlet/fileField?field=AttachmentBody";
	hideImage = false;
	ideaListWrapper;
	labelAriaWrapper =label_AriaWrapper;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		if (!this.recordId) {
			this.recordId = getRecordIdFromURL();
		}
		
		this.getCommonSetting();
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'getcommonsettings', {id: this.listId, value: this.settings});
		fireEvent(this.pageRef, 'getideainfo', {id: this.listId, value: this.ideaListWrapper});
	}
	
	get imageUrl() {
		if (this.idea && this.idea.AttachmentName) {
			this.hideImage = false;
			return ` ${this.sitePrefix}${this.ideaImageURL}` + '&entityId=' + this.idea.Id;
		}
		return undefined;
	}
	
	get layoutValue() {
		return this.layout === 'Card' ?  'vertical' : 'horizontal';
	}
	
	get viewlayoutVariant(){
		return (this.layoutVariant === 'None') ? 'default' : 'featured';
	}
	get autoSlds() {
		return inLexMode();
	}
	getCommonSetting() {
		getCommonSettings({
			zoneName: this.zoneName,
			loadCustomFields: true,
			fieldSetName: this.customFieldSetName
		})
			.then(result => {
				this.settings = result;
				this.customFields = result.customFields;
				this.sitePath = result.sitePath;
				this.zoneId = result.zoneId;
				
				let sitePath = result.sitePath;
				let position = sitePath.lastIndexOf('/s');
				this.sitePrefix = sitePath.substring(0, position);
				
				let isAuthenticated = result.isAuthenticated;
				
				if ((this.authenticatedOnly && isAuthenticated) || !this.authenticatedOnly) {
					getIdeaRecord({
						zoneId: this.zoneId,
						recordId: this.recordId,
						customFieldSetName: this.customFieldSetName
					})
						.then(result => {
							let ideaListWrapper = result;
							this.ideaListWrapper = ideaListWrapper;
							let idea = ideaListWrapper.ideaList[0];
							this.createCustomFields(idea);
							this.ideaDesc = idea.Body;
							this.idea = idea;
						})
						.catch(error => {
							console.error("Error occurred getting idea record:" + JSON.stringify(error));
						})
				}
			})
			.catch(error => {
				console.error("Error occurred getting common settings:" + JSON.stringify(error));
			})
	}
	
	createCustomFields(idea) {
		let customFields = JSON.parse(JSON.stringify(this.customFields));
		let strIdea = JSON.parse(JSON.stringify(idea));
		let newCus = [];
		if (strIdea) {
			if (customFields) {
				customFields.forEach(field => {
					field.value = strIdea[field.apiName] || '';
					switch (field.align) {
						case 'center':
							field.alignClass = 'slds-align_absolute-center';
							break;
						case 'right':
							field.alignClass = 'slds-float_right';
							break;
						default:
							field.alignClass = 'slds-text-align_left';
							break;
					}
					newCus.push(field);
				});
			}
			this.customFields = newCus;
			// console.log('-after custom customFields---' + JSON.stringify(this.customFields));
		}
	}
}