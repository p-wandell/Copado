/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {api, LightningElement, wire} from 'lwc';

import {custom, enableVote, getRecordIdFromURL, updateIdeaValues} from 'c/x7sIdeasBase';
import {fireEvent, inLex, inLexMode, registerListener, unregisterAllListeners,showToast} from 'c/x7sShrUtils';
import {CurrentPageReference} from 'lightning/navigation';

import getVote from '@salesforce/apex/x7sIdeasViewController.getVote';
import setVote from '@salesforce/apex/x7sIdeasViewController.vote';
import getIdeaRecord from '@salesforce/apex/x7sIdeasViewController.getIdeaRecord';
import getTotalVoterCount from '@salesforce/apex/x7sIdeasVotersController.getTotalVoterCount';
import getIdeaVoters from '@salesforce/apex/x7sIdeasVotersController.getIdeaVoters';
import getVotingLimitsForAccount from '@salesforce/apex/x7sIdeasViewController.getVotingLimitsForAccount';

import labelVoteClosed from "@salesforce/label/c.x7sIdeasVoteClosed";
import labelVoteOnIdeaCTA from "@salesforce/label/c.x7sIdeasVoteOnIdeaCTA";
import labelVotedOnIdeaCTA from "@salesforce/label/c.x7sIdeasVotedOnIdeaCTA";
import labelIdeaPoints from "@salesforce/label/c.x7sIdeasVotePoints";
import labelSupporters from "@salesforce/label/c.x7sIdeasVoteLabelSupporters";
import labelSupporterSingular from "@salesforce/label/c.x7sIdeasVoteLabelSupporter";
import labelAccountVotingLimit from "@salesforce/label/c.x7sIdeasAccoutVotingLimitText";
import labelCurrentVoting from "@salesforce/label/c.x7sIdeasVotesCurrentLimitText";
import labelMore from "@salesforce/label/c.x7sIdeasVoteMoreSupporters";
import labelAria from "@salesforce/label/c.x7sIdeasVoteAriaLabel";
import deleteVote from '@salesforce/apex/x7sIdeasViewController.deleteVote';
import labelDelete from '@salesforce/label/c.x7sIdeasTableDeleteLabel';

export default class X7sIdeasVote extends LightningElement {
	
	@api recordId;
	@api listId = "ID_1";
	@api showPoints = false;
	@api displaySupporters = false;
	@api numberSupporters = 12;
	@api showAccountLimitHeaderText = false;
	@api headerText = "Account Voting";
	@api currentLimit = "Current Account Votes";
	@api totalLimit = "Account Voting Limit";
	@api customClass = "";
	@api variant = "Featured";
	@api showRemoveVote = false;
	@api allowVote="true";
	
	zoneId;
	disableDownVoting = false;
	voteDisableStatus = "";
	showAlternateCTA = false;
	enableVote = true;
	settings;
	currentVote;
	idea;
	
	//For Voting Limit for Account
	totalVoteCount = 0;
	currentVoteCount = 0;
	
	//For supporters
	userProfileURL = "/profile/";
	userProfileSuffix = "";
	showNickname = true;
	totalVoterCount;
	voters=[];
	sitePath;
	voteId;
	labels = {
		labelIdeaPoints,
		labelAccountVotingLimit,
		labelCurrentVoting,
		labelMore,
		labelAria
	}
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		if (!this.recordId) {
			this.recordId = getRecordIdFromURL();
		}
		
		registerListener("getcommonsettings", this.handleCommonSettings, this);
		registerListener("getideainfo", this.handleIdeaInfo, this);
		
		this.getAccountVotingLimit();
		
		if (this.displaySupporters) {
			this.getIdeaVoters();
		}
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'ideaspoints');
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get isIdeaId() {
		return this.idea && this.idea.Id;
	}
	
	get currentVoteId() {
		return this.currentVote !== undefined ? this.currentVote.Id : undefined;
	}
	
	get enableVoteValue() {
		return this.idea !== undefined ? this.idea.enableVote : undefined;
	}
	
	get ideaId() {
		return this.idea !== undefined ? this.idea.Id : undefined;
	}
	
	get currentVoteType() {
		return this.currentVote !== undefined ? this.currentVote.Type : undefined;
	}
	
	get showVoting() {
		return this.enableVote && this.currentVote != null;
	}
	
	get points() {
		return this.idea ? this.idea.VoteTotal : 0;
	}
	
	get titleText() {
		if (this.enableVote && this.currentVote != null) {
			if (this.showAlternateCTA) {
				return !this.idea.enableVote ? labelVoteClosed : this.currentVote.Id ? labelVotedOnIdeaCTA : labelVoteOnIdeaCTA;
			} else {
				return labelVoteOnIdeaCTA;
			}
		}
		return undefined;
	}
	
	get supportersTitle() {
		let voterCount = this.totalVoterCount || 0;
		let title = this.totalVoterCount > 1 ? labelSupporters : labelSupporterSingular;
		return voterCount + ' ' + title;
	}
	
	get showMoreVoters() {
		return this.totalVoterCount - this.numberSupporters > 0;
	}
	
	get additionalVoterNum() {
		return this.totalVoterCount - this.numberSupporters;
	}
	
	get istotalVoteCount() {
		return this.totalVoteCount !== 0;
	}
	
	get showHeaderText() {
		return this.showAccountLimitHeaderText && this.headerText != null;
	}
	get displayVariant(){
		return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}
	get ideaCreatedBy(){
		if (this.idea && this.idea.CreatedBy) {
			return this.idea.CreatedBy.Id;
		}
	}
	get autoSlds() {
		return inLexMode();
	}
	handleIdeaInfo(event) {
		if (this.listId === event.id) {
			let ideasListWrapper = event.value;
			this.idea = updateIdeaValues(
				ideasListWrapper.ideaList[0],
				ideasListWrapper.topicNameToId,
				ideasListWrapper.sitePath,
				'',
				this.voteDisableStatus,
				this.pageRef);
			
			getVote({
				recordId: this.recordId
			})
				.then(result => {
					this.currentVote = result;
					if (this.currentVote) {
						this.voteId = this.currentVote.Id;
					}
				})
				.catch(error => {
					console.error("Error occurred getting vote details:" + error);
				})
		}
	}
	
	handleCommonSettings(event) {
		if (this.listId === event.id) {
			let settings = event.value;
			if (settings) {
				this.settings = settings;
				this.zoneId = settings.zoneId;
				this.disableDownVoting = !settings.allowDownVoting;
				this.voteDisableStatus = settings.voteDisableStatus || '';
				this.showAlternateCTA = settings.showAlternateCTA;
				this.sitePath = settings.sitePath;
				this.showNickname = settings.nicknameEnabled;
				this.enableVote = enableVote(settings);
			}
		}
	}
	
	getAccountVotingLimit() {
		getVotingLimitsForAccount({
			ideaId: this.recordId
		})
			.then(result => {
				let limit = result;
				this.totalVoteCount = limit.totalVotes;
				this.currentVoteCount = limit.currentVoteCount;
			})
			.catch(error => {
				console.error("Error occurred getting voting limits for account:" + error);
			})
	}
	
	getIdeaVoters() {
		if (inLexMode()) {
			this.userProfileURL = custom.profileUrl.lex;
			this.userProfileSuffix = custom.profileUrl.view;
		} else {
			this.userProfileURL = custom.profileUrl.community;
		}
		getTotalVoterCount({
			recordId: this.recordId
		})
			.then(result => {
				this.totalVoterCount = result;
				if (result > 0) {
					getIdeaVoters({
						recordId: this.recordId,
						numResults: this.numberSupporters
					})
						.then(result => {
							let voters = result;
							let votersToLinks = [];
							if (voters) {
								for (let i = 0; i < voters.length; i++) {
									let voterObject = {
										Id: voters[i].Id,
										Name: voters[i].Name,
										SmallPhotoUrl: voters[i].SmallPhotoUrl,
										CommunityNickname: voters[i].CommunityNickname,
										avatarlink: this.sitePath + this.userProfileURL + voters[i].Id + this.userProfileSuffix,
										avatarlinkTitle: this.showNickname ? voters[i].CommunityNickname : voters[i].Name
									};
									votersToLinks.push(voterObject);
								}
								this.voters = votersToLinks;
							}
						})
						.catch(error => {
							console.error("Error occurred getting Idea voters:" + error);
						})
				}
			})
			.catch(error => {
				console.error("Error occurred getting total vote count:" + error);
			})
	}
	
	handleVoteUp() {
		this.submitVote(true);
	}
	
	handleVoteDown() {
		this.submitVote(false);
	}
	
	submitVote(isUp) {
		setVote({
			recordId: this.recordId,
			isUp: isUp
		})
			.then(vote => {
				this.currentVote = vote;
				location.reload();
				getIdeaRecord({
					recordId: this.recordId,
					zoneId: this.zoneId,
					customFieldSetName: ''
				})
					.then(result => {
						let idea = updateIdeaValues(
							result.ideaList[0],
							result.topicNameToId,
							result.sitePath,
							'', '', this.pageRef);
						let currentVoteCount = this.currentVoteCount;
						currentVoteCount = currentVoteCount + 1;
						this.currentVoteCount = currentVoteCount;
						this.idea = idea;
					})
					.catch(error => {
						console.error("Error occurred getting Idea details:" + error);
					})
			})
			.catch(error => {
				console.error("Error occurred getting vote:" + error);
			})
	}
	handleRemoveVote(){
		deleteVote({
			recordId: this.voteId
		})
		.then(vote => {
			if(vote){
				this.showRemoveVote = false;
				showToast(labelDelete, 'Vote', 'success', 'dismissable');
				location.reload();
            }else{
                showToast(labelDelete, 'Unable to Delete', 'error', 'dismissable');
            }
		})
		.catch(error => {
			let errors = error;
		});
	}
}