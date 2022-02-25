/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';

import {inLex,inLexMode} from 'c/x7sShrUtils';

import getComments from '@salesforce/apex/x7sIdeasStatusComments.getComments';
import getSitePrefix from '@salesforce/apex/x7sIdeasStatusComments.getSitePrefix';
import {CurrentPageReference} from 'lightning/navigation';

import labelTitle from "@salesforce/label/c.x7sIdeasStatusCommentsTitle";
import labelCommentBy from "@salesforce/label/c.x7sIdeasDetailLabelBy";
import labelAria from "@salesforce/label/c.x7sIdeasStatusCommentsAriaLabel";
import {custom, getRecordIdFromURL} from "c/x7sIdeasBase";

export default class X7sIdeasStatusComments extends LightningElement {
	
	@api zoneName = "Internal Zone";
	@api recordId;
	@api customClass = "";
	@api variant = "Featured";
	@api listId = "ID_1";
	
	userProfileURL = "/profile/";
	summaryWrapper;
	sitePrefix;
	
	labels = {
		labelTitle,
		labelAria
	}
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		if (!this.recordId) {
			let editUrl = window.location.href;
			let newURL = new URL(editUrl).searchParams;
			this.recordId = newURL.get(inLexMode() ? custom.urlParams.lexRecordId : "ideaId");
		}
		
		this.get_SitePrefix();
		this.getStatusComments();
	}
	get showComments() {
		return this.summaryWrapper && this.summaryWrapper.length > 0;
	}
	
	get commentByLabel() {
		return ' ' + labelCommentBy + ' ';
	}
	get displayVariant(){
		return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}
	get autoSlds() {
		return inLexMode();
	}
	getStatusComments() {
		getComments({
			ideaId: this.recordId
		})
			.then(result => {
				let summaryWrapper = result;
				if (summaryWrapper) {
					for (let i = 0; i < summaryWrapper.length; i++) {
						let summary = summaryWrapper[i];
						summary.userProfileURL = this.sitePrefix + '/profile/' + summary.changedById;
					}
				}
				this.summaryWrapper = summaryWrapper;
			})
			.catch(error => {
				console.error("Error occurred getting status comments:" + error);
			})
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				this.sitePrefix = result;
			})
	}
}