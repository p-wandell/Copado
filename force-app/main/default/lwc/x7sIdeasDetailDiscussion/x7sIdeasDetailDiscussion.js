/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import currentUserId from '@salesforce/user/Id';

import {registerListener, unregisterAllListeners,inLexMode} from 'c/x7sShrUtils';
import {updateIdeaValues, enableCommenting, getRecordIdFromURL} from 'c/x7sIdeasBase';
import userAuthorizedChatter from '@salesforce/apex/x7sIdeasViewController.userAuthorizedChatter';

import labelTabComments from "@salesforce/label/c.x7sIdeasDetailDisTabComments";
import labelTabFiles from "@salesforce/label/c.x7sIdeasDetailDisTabFiles";
import labelAria from "@salesforce/label/c.x7sIdeasDetailDiscussionAriaLabel";
// import labelTabFeed from "@salesforce/label/c.x7sIdeasDetailDisTabFeed";

export default class X7sIdeasDetailDiscussion extends LightningElement {
	
	@api recordId;
	@api zoneName = 'Internal Zone';
	@api listId = "ID_1";
	@api customClass = "";
	@api variant = "Featured";
	
	@api selectedTab = "comments";
	@api showComments = false;
	@api numComments = 6;
	@api showPagination = false;
	@api showSort = false;
	@api sortOrder = "LatestComment";
	// @api showChatter = false;
	// @api feedTitle = "";
	// @api showPublisher = false;
	// @api showFeed = false;
	@api showFiles = false;
	@api filesTitle = "";
	@api filesAccept = ".pdf,.png";
	@api filesVisibility = "AllUsers";
	@api showFileUploader = false;
	@api showFileViewer = false;
	
	idea;
	showTabs = false;
	// showCommentContent = false;
	// showFeedContent = false;
	// showFilesContent = false;
	enableCanComment = false;
	
	labels = {
		labelTabComments,
		// labelTabFeed,
		labelTabFiles,
		labelAria
	};
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		if (!this.recordId) {
			this.recordId = getRecordIdFromURL();
		}
		
		registerListener("getcommonsettings", this.handleCommonSettings, this);
		registerListener("getideainfo", this.handleIdeaInfo, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get isIdeaId() {
		return this.idea && this.idea.Id;
	}
	
	// get showFeedTab(){
	//     return this.showFeed && this.showTabs;
	// }
	
	get allowHtml() {
		return this.idea && this.idea.IsHtml;
	}
	get displayVariant(){
		return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}
	get autoSlds() {
		return inLexMode();
	}
	handleCommonSettings(event) {
		if (this.listId === event.id) {
			let settings = event.value;
			this.enableCanComment = enableCommenting(settings);
		}
	}
	
	handleIdeaInfo(event) {
		if (this.listId === event.id) {
			let ideasListWrapper = event.value;
			let idea = updateIdeaValues(ideasListWrapper.ideaList[0], ideasListWrapper.topicNameToId, ideasListWrapper.sitePath, '', '', this.pageRef);
			this.idea = idea;
			const userId = currentUserId;
			let showTabs = false;
			
			if (idea) {
				if (idea.CreatedBy.Id === userId) {
					showTabs = true;
				} else {
					if (idea['Requested_By__c'] && idea.Requested_By__c.Id === userId)
						showTabs = true;
					else {
						userAuthorizedChatter()
							.then(result => {
								showTabs = result;
								this.showTabs = showTabs;
								this.showFileUploader = showTabs;
							})
							.catch(error => {
								console.error("Error occurred getting user authorized chatter:" + error);
							})
					}
				}
			}
			this.showTabs = showTabs;
			this.showFileUploader = showTabs;
		}
	}
	
	handleActive(event) {
		let activeTab = event.target.value;
		
		if (activeTab === 'comments') {
			//console.log("We are in comment tab");
			
			// }else if(activeTab === 'discussion'){
			//     console.log("We are in Feed tab");
			
		} else if (activeTab === 'files') {
			//console.log("We are in files tab");
		}
	}
}