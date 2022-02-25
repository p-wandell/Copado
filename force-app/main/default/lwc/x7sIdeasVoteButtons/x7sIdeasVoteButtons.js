/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api} from 'lwc';
import currentUserId from '@salesforce/user/Id';
import {showToast} from 'c/x7sShrUtils';
import getVotingDetails from "@salesforce/apex/x7sIdeasListController.getVotingDetails";

import ss_idea_label_UpVote from "@salesforce/label/c.x7sIdeasVoteButtonsLabelUpVote";
import ss_idea_label_UpVoting from "@salesforce/label/c.x7sIdeasVoteButtonsLabelUpVoting";
import ss_idea_label_UpVoted from "@salesforce/label/c.x7sIdeasVoteButtonsLabelUpVoted";
import ss_idea_label_DownVote from "@salesforce/label/c.x7sIdeasVoteButtonsLabelDownVote";
import ss_idea_label_DownVoted from "@salesforce/label/c.x7sIdeasVoteButtonsLabelDownVoted";
import ss_idea_label_accountVotingLimit from "@salesforce/label/c.x7sIdeasVoteButtonsMsgAccountVotingLimit";
import label_VoteClear from "@salesforce/label/c.x7sIdeasVoteClear";


export default class X7sIdeasVoteButtons extends LightningElement {
	
	@api ideaId = '';
	@api enableVote = "true";
	@api userHasVoted=false;
	@api userVoteType = '';
	@api disableDownVoting;
	@api reduceButtonLabels;
	@api isVoting = false;
	@api currentVoteCount = "0";
	@api totalVoteCount = "0";
	@api accountLimitReachedMessage = ss_idea_label_accountVotingLimit;
	@api showRemoveVote;
	@api ideaCreatedBy;
	
	labelVote = ss_idea_label_UpVote;
	labelVoting = ss_idea_label_UpVoting;
	labelVoted = ss_idea_label_UpVoted;
	labelDownVote = ss_idea_label_DownVote;
	labelDownVoted = ss_idea_label_DownVoted;
	labelVoteClear =label_VoteClear;
	accountVoteLimitReached = false;
	error;
	
	get userHasVotedIconName() {
		return (this.userVoteType === 'Down' && this.disableDownVoting === false) ? 'utility:dislike' : 'utility:like';
	}
	
	get userHasVotedLabel() {
		return (this.userVoteType === 'Down' && this.disableDownVoting === false) ? `${this.labelDownVoted}` : `${this.labelVoted}`;
	}
	
	get disableButtonIcon() {
		return (!this.enableVote || this.accountVoteLimitReached);
	}
	
	get getDisableDownVoting() {
		return !this.disableDownVoting;
	}
	
	get displayRemoveVoteButton(){
		return (this.ideaCreatedBy !== currentUserId) && (this.userHasVoted && this.showRemoveVote);
	}
	handleVote() {
		this.voting('Up');
	}
	
	handleDownVote() {
		this.voting('Down');
	}
	
	voting(voteType) {
		let currentVoteCount = this.currentVoteCount;
		let totalVoteCount = this.totalVoteCount;
		
		getVotingDetails({ideaId: this.ideaId})
			.then(result => {
				let res = result;
				//console.log('Voting LIMIT: ' + JSON.stringify(res));
				totalVoteCount = res.totalVotes;
				//console.log('totalVoteCount: ' + totalVoteCount);
				
				currentVoteCount = res.currentVoteCount;
				//console.log('currentVoteCount: ' + currentVoteCount);
				
				if (currentVoteCount < totalVoteCount || totalVoteCount === 0) {
					if (voteType === 'Up') {
						this.upVoteEvent(voteType, totalVoteCount);
					} else {
						this.downVoteEvent(voteType, totalVoteCount);
					}
				} else {
					showToast(this.accountLimitReachedMessage, '', 'info', 'dismissable');
				}
			})
			.catch(error => {
				this.error = error;
				console.error(error);
			});
	}
	
	upVoteEvent(voteType, totalVoteCount) {
		const upVoteEvent = new CustomEvent('upvote',
			{
				ideaId: this.ideaId,
				voteType: voteType,
				voteCount: totalVoteCount
			});
		
		// Dispatches the event.
		this.dispatchEvent(upVoteEvent);
	}
	
	downVoteEvent(voteType, totalVoteCount) {
		const downVoteEvent = new CustomEvent('downvote',
			{
				ideaId: this.ideaId,
				voteType: voteType,
				voteCount: totalVoteCount
			});
		
		// Dispatches the event.
		this.dispatchEvent(downVoteEvent);
	}
	handleRemoveVote(){
		const removeVoteEvent = new CustomEvent('removevote',{});
		this.dispatchEvent(removeVoteEvent);
	}

}