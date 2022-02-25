/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {api, LightningElement, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import currentUserId from '@salesforce/user/Id';

import {formatText, inLexMode, showToast} from 'c/x7sShrUtils';
import {custom, enableSubscribe, getRecordIdFromURL, updateIdeaValues} from 'c/x7sIdeasBase';

import getCommonSettings from '@salesforce/apex/x7sIdeasViewController.getCommonSettings';
import isRecordEditable from '@salesforce/apex/x7sIdeasViewController.isRecordEditable';
import isRecordDeletable from '@salesforce/apex/x7sIdeasViewController.isRecordDeletable';
import getIdeaRecord from '@salesforce/apex/x7sIdeasViewController.getIdeaRecord';
import isFollowingIdea from '@salesforce/apex/x7sIdeasViewController.isFollowingIdea';
import unFollowIdea from '@salesforce/apex/x7sIdeasViewController.unFollowIdea';
import followIdea from '@salesforce/apex/x7sIdeasViewController.followIdea';
import deleteIdea from '@salesforce/apex/x7sIdeasViewController.deleteIdea';


import labelIdeaButtonfollow from "@salesforce/label/c.x7sIdeasDetailButtonFollow";
import labelIdeaButtonfollowing from "@salesforce/label/c.x7sIdeasDetailButtonFollowing";
import labelIdeaButtonUnfollow from "@salesforce/label/c.x7sIdeasDetailButtonUnFollow";
import labelIdeaTooltipFollow from "@salesforce/label/c.x7sIdeasDetailTooltipFollow";
import labelEdit from "@salesforce/label/c.x7sIdeasDetailLabelEdit";
import labelDelete from "@salesforce/label/c.x7sIdeasDetailLabelDelete";
import labelIdeaBy from "@salesforce/label/c.x7sIdeasDetailLabelBy";
import labelExploreOtherIdeas from "@salesforce/label/c.x7sIdeasLabelExploreOtherIdeas";
import labelDeleteConfirmMsg from "@salesforce/label/c.x7sIdeasDetailRemoveThisRecord";
import labelDeleteRecordToast from "@salesforce/label/c.x7sIdeasDetailLabelDeleted";
import labelDeleteRecordFailed from "@salesforce/label/c.x7sIdeasDetailErrorDelete";
import labelPostedIn from "@salesforce/label/c.x7sIdeasDetailBannerPostedIn";
import labelAriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";

export default class X7sIdeasDetailBanner extends NavigationMixin(LightningElement) {
	
	@api zoneName = "Internal Zone";
	@api displayCategories = false;
	@api displayPostDateAuthor = false;
	@api displayTheme = false;
	@api allowExploreIdeas = false;
	@api ideaDetailURL = "X7S_Idea_Detail__c";
	@api ideaNewURL = " X7S_Idea Create Edit__c";
	@api ideasListURL = "X7S_Idea__c";
	@api canFollow = false;
	@api canEdit = false;
	@api canDelete = false;
	@api editMyIdea = false;
	@api variant = "Featured";
	@api customClass = "";
	@api recordId;
	
	sitePath;
	isNicknameDisplayEnabled = true;
	zoneId = "";
	userProfileURL;
	ideaTitle;
	idea;
	isFollowing = false;
	buttonVariant = "neutral";
	ideaCreatedDate;
	topics;
	categories;
	ideaTheme;
	ideaStatus;
	
	labels = {
		labelIdeaButtonfollow,
		labelIdeaButtonfollowing,
		labelIdeaButtonUnfollow,
		labelIdeaTooltipFollow,
		labelEdit,
		labelDelete,
		labelIdeaBy,
		labelExploreOtherIdeas,
		labelPostedIn,
		labelAriaWrapper
	}
	
	@wire(CurrentPageReference) pageRef;
	
	get showMetaSlot() {
		return this.displayPostDateAuthor || this.canEdit || this.canDelete || this.allowExploreIdeas || this.showCategories;
	}
	
	get showCategories() {
		return this.categories && this.displayCategories;
	}
	
	get showAuthorCatSlot() {
		return this.displayPostDateAuthor || this.showCategories;
	}
	
	get showTheme() {
		return this.displayTheme && this.ideaTheme;
	}
	
	get displayVariant(){
	return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}

	get categoriesToDisplay() {
		return labelPostedIn + ' [' + this.categories + ']';
	}
	get showListButton(){
		return (this.allowExploreIdeas && this.ideasListURL !== '');
	}
	get autoSlds() {
		return inLexMode();
	}
	connectedCallback() {
		if (!this.recordId) {
			this.recordId = getRecordIdFromURL();
		}
		
		this.getCommonSetting();
	}
	
	getCommonSetting() {
		getCommonSettings({
			zoneName: this.zoneName,
			loadCustomFields: false,
			fieldSetName: ''
		})
			.then(result => {
				this.sitePath = result.sitePath;
				this.isNicknameDisplayEnabled = result.nicknameEnabled;
				this.zoneId = result.zoneId;
				this.canFollow = enableSubscribe(result);
				let recordId = this.recordId;
				
				if (recordId) {
					if (this.canEdit) {
						this.checkIsRecordEditable();
					}
					if (this.canDelete) {
						this.checkIsRecordDeletable();
					}
					this.getIdeaRecordDetail();
				}
			})
			.catch(error => {
				console.error("Error has ocuurred getting common settings:" + JSON.stringify(error));
			})
	}
	
	getIdeaRecordDetail() {
		getIdeaRecord({
			zoneId: this.zoneId,
			recordId: this.recordId,
			customFieldSetName: ''
		}).then(result => {
			let ideaListWrapper = result;
			let idea = updateIdeaValues(ideaListWrapper.ideaList[0], ideaListWrapper.topicNameToId, ideaListWrapper.sitePath, '', '', this.pageRef);
			let topicName = ideaListWrapper.ideaList[0].Related_Topic_Name__c;
			//Get topic list
			if (topicName && ideaListWrapper.topicNameToId) {
				let data = ideaListWrapper.topicNameToId;
				this.topics = ([{Name: topicName, Id: data[topicName], Topic: {Id: data[topicName], Name: topicName}}]);
			}
			
			this.idea = idea;
			
			if (idea && idea.CreatedBy) {
				this.ideaStatus = idea.Status;
				this.ideaTitle = idea.Title;
				this.ideaCreatedDate = new Date(idea.CreatedDate);
				if (inLexMode()) {
					this.userProfileURL = '/lightning/r/User/' + idea.CreatedBy.Id + '/view';
				} else {
					this.userProfileURL = this.sitePath + '/profile/' + idea.CreatedBy.Id;
				}
				this.ideaUserName = this.isNicknameDisplayEnabled ? idea.CreatedBy.CommunityNickname : idea.CreatedBy.Name;
				
				if (this.displayCategories) {
					let tempCategories = idea.Categories.split(";");
					this.categories = tempCategories[0];
				}
				
				if (this.displayTheme) {
					this.ideaTheme = idea.IdeaTheme.Title;
				}
				if (this.editMyIdea) {
					const userId = currentUserId;
					const isOwner = idea.CreatedBy.Id === userId;
					
					if (this.canEdit) {
						this.canEdit = isOwner;
					}
					if (this.canDelete) {
						this.canDelete = isOwner;
					}
				}
				
				if (this.canFollow) {
					isFollowingIdea({
						ideaId: this.recordId
					})
						.then(result => {
							this.isFollowing = result;
						})
						.catch(error => {
							console.error("Error occurred checking isFollowingIdea:" + error);
						})
				}
			}
			
		})
			.catch(error => {
				console.error("Error occurred getting Idea record:" + JSON.stringify(error));
			})
	}
	
	enableVoting(ideaStatus, voteDisableStatusList) {
		let enableVote = true;
		
		if (voteDisableStatusList) {
			let statusList = voteDisableStatusList.split(custom.VOTE_STATUS_DELIMITER);
			if (statusList.includes(ideaStatus)) {
				enableVote = false;
			}
		}
		return enableVote;
	}
	
	checkIsRecordEditable() {
		isRecordEditable({
			recordId: this.recordId
		})
			.then(result => {
				this.canEdit = result;
			})
			.catch(error => {
				console.error("Error occurred checking isRecordEditable:" + error);
			})
	}
	
	checkIsRecordDeletable() {
		isRecordDeletable({
			recordId: this.recordId
		})
			.then(result => {
				this.canDelete = result;
			})
			.catch(error => {
				console.error("Error occurred checking isRecordDeletable:" + error);
			})
	}
	
	enableSubscribe(settings) {
		return settings.disableReadOnlyUsers ? settings.isAuthenticated && settings.canCreateNew : true;
	}
	
	handleEdit() {
		let url = this.ideaNewURL;
		
		if (url) {
			let pageRef = inLexMode() ? {
				type: 'standard__webPage',
				attributes: {
					url: custom.urlParams.lexPrefix + url + '?' + custom.urlParams.lexRecordId + '=' + this.recordId
				},
				state: {
					'ideaId': this.recordId,
					'isEdit': true
				}
			} : {
				type: 'comm__namedPage',
				attributes: {
					name: url
				},
				state: {
					'ideaId': this.recordId,
					'isEdit': true
				}
			};
			
			this[NavigationMixin.Navigate](pageRef);
		}
	}
	
	handleDelete(event) {
		let idea = this.idea;
		if (confirm(formatText(labelDeleteConfirmMsg))) {
			
			deleteIdea({
				ideaId: idea.Id
			})
				.then(result => {
					let deleteToast = labelDeleteRecordToast.replace('{0}', idea.Title);
					showToast(labelDelete, deleteToast, 'success', 'dismissable');
					this.gotoUrl(this.ideasListURL);
				})
				.catch(error => {
					console.error("Error occurred deleting Idea:" + error);
					
					let deleteFailed = labelDeleteRecordFailed
						.replace('{0}', idea.Title)
						.replace('{1}', error[0]);
					showToast(labelDelete, deleteFailed, 'error', 'dismissable');
				})
		}
	}
	
	handleFollowClick(event) {
		const isFollowing = this.isFollowing;
		if (isFollowing) {
			this.startUnfollowingIdea(isFollowing);
		} else {
			this.startFollowingIdea(isFollowing);
		}
	}
	
	startUnfollowingIdea(isFollowing) {
		unFollowIdea({
			ideaId: this.recordId
		})
			.then(result => {
				this.isFollowing = !this.isFollowing;
			})
			.catch(error => {
				console.error("Error occurred while unfollowing idea:" + error);
			})
	}
	
	startFollowingIdea(isFollowing) {
		followIdea({
			ideaId: this.recordId
		})
			.then(result => {
				this.isFollowing = !this.isFollowing;
			})
			.catch(error => {
				console.error("Error occurred while following idea:" + error);
			})
	}
	
	handleExploreIdeas() {
		this.gotoUrl(this.ideasListURL);
	}
	
	gotoUrl(url) {
		let pageRef = inLexMode() ? {
			type: 'standard__webPage',
			attributes: {
				url: custom.urlParams.lexPrefix + url
			}
		} : {
			type: 'comm__namedPage',
			attributes: {
				name: url
			}
		};
		this[NavigationMixin.Navigate](pageRef);
	}
}