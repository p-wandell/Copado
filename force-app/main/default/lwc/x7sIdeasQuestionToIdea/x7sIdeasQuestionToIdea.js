/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';

import getQuestionDetail from "@salesforce/apex/x7sIdeasNewController.getQuestionDetail";

import ss_idea_label_Close from "@salesforce/label/c.x7sIdeasQuestionToIdeaLabelClose";
import x7s_Question_To_Idea_Button_Label from "@salesforce/label/c.x7sIdeasQuestionToIdeaButtonLabel";

export default class X7sIdeasQuestionToIdea extends LightningElement {
	
	@api zoneName = 'ideas7s';
	@api ideaListURL = '/ideas/';
	@api questionToIdeaButtonLabel = x7s_Question_To_Idea_Button_Label;
	@api showRequestedBy = "true";
	@api topicRequired = false;
	@api useTopics = "true";
	@api allowCategories = "true";
	@api recordId;
	@track currIdea = {'sobjectType': 'Idea', 'Title': ''};
	
	createIdeaClick = false;
	isNewIdea = false;
	selectedUserId = '';
	selectedUser;
	showCross = false;
	labelModalClose = ss_idea_label_Close;
	error;
	
	connectedCallback() {
		getQuestionDetail({recordId: this.recordId})
			.then(result => {
				let _resp = result;
				//console.log('RESP from Ideas: ' + JSON.stringify(_resp));
				if (_resp.requestedBy) {
					_resp.Requested_By__c = _resp.requestedBy.Id;
				}
				
				this.selectedUser = _resp.requestedBy;
				if (_resp.requestedBy) {
					this.selectedUserId = _resp.requestedBy.Id;
				}
				
				this.currIdea = _resp;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	handleConvertToIdeaCancel() {
		this.createIdeaClick = true;
	}
	
	closeIdeaPage() {
		this.createIdeaClick = false;
	}
}