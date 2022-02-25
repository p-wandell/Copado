/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import { classSet } from "c/x7sShrUtils";

import labelButtonFollow from "@salesforce/label/c.x7sMembersButtonFollow";
import labelButtonFollowing from "@salesforce/label/c.x7sMembersButtonFollowing";
import labelButtonUnFollow from "@salesforce/label/c.x7sMembersButtonUnFollow";
import labelKnowledgeableAbout from "@salesforce/label/c.x7sMembersKnowledgeableAbout";
import labelLikes from "@salesforce/label/c.x7sMembersLabelLikes";
import labelPosts from "@salesforce/label/c.x7sMembersLabelPosts";
import labelFollowers from "@salesforce/label/c.x7sMembersLabelFollowers";
import unfollowRecord from "@salesforce/apex/x7sMembersController.unfollowRecord";
import followRecord from "@salesforce/apex/x7sMembersController.followRecord";

export default class X7sMembersListItem extends LightningElement {
	@api member = {};
	@api showImages;
	@api showAvatar;
	@api displayTitle;
	@api displayPhone;
	@api clickToCall;
	@api displayEmail;
	@api displayKnowledge;
	@api displayFollowButton;
	@api displayChatterStats;
	@api tileVariant = 'default';
	@api textAlign = 'center';
	@api layout= 'vertical'; // vertical, horizontal
	selected = false;
	@api chkCustomFieldLength1;
	@api chkCustomFieldLength2;
	@api chkCustomFieldLength3;
	@api chkCustomFieldLength4;
	@api chkCustomFieldLength5;
	@api chkCustomFieldLength6;
	@api customLabel1;
	@api customLabel2;
	@api customLabel3;
	@api customLabel4;
	@api customLabel5;
	@api customLabel6;
	
	labels = {
		labelButtonFollow,
		labelButtonFollowing,
		labelButtonUnFollow: labelButtonUnFollow,
		labelKnowledgeableAbout,
		labelFollowers,
		labelLikes,
		labelPosts
	};
	connectedCallback() {
        // console.log('group', JSON.parse(JSON.stringify(this.group)));
        this.selected = this.member && this.member.isFollowing;
    }
	get showTitle() {
		return this.displayTitle && this.member.showTitle;
	}
	
	get showPhone() {
		return this.displayPhone && this.member.showPhone;
	}
	
	get showEmail() {
		return this.displayEmail && this.member.showEmail;
	}
	
	get showKnowledgeable () {
		return this.displayKnowledge && this.member.strKnowledgeTopics;
	}
	get useAvatar(){
        return (this.showImages && this.showAvatar);
	}
	get hide_image(){
        return (!this.showImages);
	}
    get memberFollowRowClass() {
        return classSet('x7s-member__like-row')
        .add({
            'slds-text-align_center': this.layout === 'vertical',
            'slds-text-align_right': this.layout === 'horizontal',
        })
        .toString();
	}	
	get customFieldAlign(){
		if(this.layout === 'vertical'){
			return `slds-align_absolute-center`;
		}
		return '';
	}
	handleFollowRecord(evt) {
		let recId = evt.target.dataset.id;
		
		if (evt.target.selected) {
			unfollowRecord({recordId: recId})
				.then(result => { let res = result;})
				.catch(error => { this.error = error;});
			evt.target.selected = false;
		} else if (!evt.target.selected) {
			followRecord({recordId: recId})
				.then(result => { let res = result; })
				.catch(error => { this.error = error;});
			evt.target.selected = true;
		}
	}
}