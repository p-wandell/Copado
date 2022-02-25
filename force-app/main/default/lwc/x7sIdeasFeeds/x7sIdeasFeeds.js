/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api} from 'lwc';

import getExtensionId from '@salesforce/apex/x7sIdeasFeedPublishController.getExtensionId';
import {getRecordIdFromURL} from "c/x7sIdeasBase";

export default class X7sIdeasFeeds extends LightningElement {
	
	@api recordId;
	@api idea;
	@api title = "";
	@api showFeed = false;
	@api showPublisher = false;
	
	connectedCallback() {
		if (!this.recordId) {
			this.recordId = getRecordIdFromURL();
		}
		
		if (this.recordId) {
			this.getExtension();
		}
	}
	
	get showTitle() {
		return this.title !== "";
	}
	
	getExtension() {
		getExtensionId({
			ideaId: this.recordId
		}).then(result => {
			//console.log("result:" + JSON.stringify(result));
			this.idea = result;
		}).catch(error => {
			console.error("Error occurred getting extension id:" + error);
		})
	}
}