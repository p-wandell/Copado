/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {api, track, LightningElement, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';

import {fireEvent, inLexMode,showToast} from 'c/x7sShrUtils';
import {custom, updateIdeaValues} from 'c/x7sIdeasBase';
import submitVote from "@salesforce/apex/x7sIdeasListController.submitVote";

import Ideas_Resources from "@salesforce/resourceUrl/x7sIdeas_Resources";
import ideaLabelBy from "@salesforce/label/c.x7sIdeasDetailLabelBy";
import labelAria from "@salesforce/label/c.x7sIdeasListItemAriaLabel";
import deleteVote from '@salesforce/apex/x7sIdeasViewController.deleteVote';
import labelDelete from '@salesforce/label/c.x7sIdeasTableDeleteLabel';

export default class X7sIdeasListItem extends LightningElement {
	
	@api idea;
	@api ideaListWrapper;
	@api showImages;
	@api tileVariant='None';
	@api textAlign = 'center';
	@api layout='Card';
	@api displayPostDateAuthor;
	@api displayStatus;
	@api isNicknameDisplayEnabled;
	@api allowVoting;
	@api enableDownVoting;
	@api ideaDetailUrl;
	@api sitePath;
	@api sitePrefix;
	@api accountLimitReachedMessage;
	@api customClass;
	@api showAvatar;
	@api showDescription = "true";
	@api descriptionLineCount = 2;
	@api showStatus;
	@api showTopic;
	@api showRemoveVote;
	@api showVote;
	
	imageHight="140px";
	ss_idealabelby = ideaLabelBy;
	ideaImageURL = '/servlet/fileField?field=AttachmentBody';
	userProfileURL = "/profile/";
	alternateUrl;
	ideaUserName;
	fromNowDate;
	@track ideaUrl;
	VOTE_STATUS_DELIMITER = ',';
	points;
	useHrefOnly = false; // Forces the shared card event handler to only rely on what is entered in the "href" of the anchor link. Used in Ideas/Lex only.
	
	labels = {
		labelAria
	}

	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.ideaAndProfileUrl();
		
		let idea = this.idea;
		if (idea && idea.VoteTotal) {
			this.points = idea.VoteTotal;
		}
		this.fromNowDate = new Date(idea.fromNow);
		if (idea && idea.CreatedBy) {
			this.ideaUserName = this.showNickName ? idea.CreatedBy.CommunityNickname : idea.CreatedBy.Name;
		}
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'ideaspoints');
	}
	
	ideaAndProfileUrl() {
		let recordUrl = this.ideaDetailUrl;
		let idea = this.idea;
		let targetUrl = this.sitePath;
		if (inLexMode()) {
			targetUrl = recordUrl;
			targetUrl += '?' + custom.urlParams.lexRecordId + '=' + idea.Id;
			this.ideaUrl = targetUrl;
			this.alternateUrl = targetUrl;
			this.useHrefOnly = true;
			this.userProfileURL = custom.profileUrl.lex + idea.CreatedBy.Id + custom.profileUrl.view;
		} else {
			this.ideaUrl = targetUrl + recordUrl + idea.Id + custom.urlParams.view;
			this.userProfileURL = this.sitePath + custom.profileUrl.community + idea.CreatedBy.Id;
		}
		
		this.ideaUserName = this.isNicknameDisplayEnabled
			? idea.CreatedBy.CommunityNickname
			: idea.CreatedBy.Name;
	}
	
	get imageUrl() {
		if (this.showImages) {
			if (this.idea && this.idea.AttachmentName) {
				return ` ${this.sitePrefix}${this.ideaImageURL}` + '&entityId=' + this.idea.Id;
			}
			return `${Ideas_Resources}` + '/Images/default-ideas.png';
		}
	}
	
	get useAvatar() {
		return (this.showImages && this.showAvatar);
	}
	
	get hide_image() {
		return (!this.showImages);
	}
	
	get getStatus() {
		if(this.showStatus){
			if (this.idea) {
				return (this.displayStatus, this.idea.Status);
			}
		}
	}
	
	get getTopic() {
		if(this.showTopic){
			if (this.idea && this.ideaListWrapper) {
				let topicName = this.idea.Related_Topic_Name__c;
			//Get topic list
				if (topicName && this.ideaListWrapper.topicNameToId) {
					let data = this.ideaListWrapper.topicNameToId;
					return ([{Name: topicName, Id: data[topicName], Topic: {Id: data[topicName], Name: topicName}}]);
				}
			}
		}
	}
	
	get disableDownVote() {
		return !this.enableDownVoting;
	}
	
	get userHasVoted() {
		if (this.idea && this.idea.Votes) {
			return this.idea.Votes[0];
		}
	}
	
	get userVoteType() {
		if (this.idea && this.idea.Votes) {
			return this.idea.Votes[0].Type;
		}
	}
	get layoutView(){
		return (this.layout === 'List' ? 'horizontal' : 'vertical');
	}
	get footerStyle() {
		if (this.layout === 'List') {
			return `display: flex;justify-content: flex-end;`;
		}
		return `display: contents;`;
	}
	get descriptionValue(){
		if(this.showDescription){
			if(this.idea && this.idea.Body){
				return this.getHtmlPlainText(this.idea.Body);
			}
		}
	}
	get ideaCreatedBy(){
		if (this.idea && this.idea.CreatedBy) {
			return this.idea.CreatedBy.Id;
		}
	}
	get viewtileVariant(){
		return (this.tileVariant === 'None') ? 'default' : 'featured';
	}
	
	getHtmlPlainText(htmlString) {
		return htmlString.replace(/<[^>]+>/g, '');
	}
	getUserProfileLink() {
		return this.userProfileURL;
	}
	
	handle_VoteUp() {
		this.submitting_vote("Up");
		fireEvent(this.pageRef, 'ideaspoints', {value: this.idea.VoteTotal});
	}
	
	handle_VoteDown() {
		this.submitting_vote("Down");
		fireEvent(this.pageRef, 'ideaspoints', {value: this.idea.VoteTotal});
	}
	
	submitting_vote(voteType) {
		submitVote({
			ideaId: this.idea.Id,
			voteType: voteType
		}).then(ideaListWrapper => {
			let topicMap = ideaListWrapper.topicNameToId;
			let currIdea = ideaListWrapper.ideaList[0];
			if (currIdea) {
				this.idea = updateIdeaValues(currIdea, topicMap, this.sitePath, '', '', this.pageRef);
			}
			
		}).catch(error => {
			this.error = error;
			console.error(error);
		});
	}
	handleRemoveVote(){
		let voteId;
		if (this.idea && this.idea.Votes) {
			voteId = this.idea.Votes[0].Id;
		}
		deleteVote({
			recordId: voteId
		})
		.then(vote => {
			if(vote){
                showToast(labelDelete, 'Vote', 'success', 'dismissable');
                eval("$A.get('e.force:refreshView').fire();");
            }else{
                showToast(labelDelete, 'Unable to Delete', 'error', 'dismissable');
            }
		})
		.catch(error => {
			let errors = error;
		});
	}
}