/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import {api, LightningElement, track} from 'lwc';
import {classSet} from "c/x7sShrUtils";
import {NavigationMixin} from 'lightning/navigation';
import {constants} from "c/x7sNewsBase";

import getSitePrefix from "@salesforce/apex/x7sNewsController.getSitePrefix";

import x7sNews_Custom from "@salesforce/resourceUrl/x7sNews_Custom";

import labelAuthorBy from "@salesforce/label/c.x7sNewsLabelAuthorBy";
import labelGroupName from "@salesforce/label/c.x7sNewsLabelGroupName"

export default class X7sNewsListItem extends NavigationMixin(LightningElement) {
	
	@api news;
	@api newsListWrapper;
	@api tileVariant = 'default';
	@api textAlign = 'center';
	@api layout = 'vertical';
	@api totalNews;
	@api profileurl;
	@api newsUrl;
	@api showAvatar;
	@api showImages;
	@api limitToSpecificGroups;
	@api isNicknameDisplayEnabled;
	@api showLikes;
	@api showComments;
	@api languageEnabled;
	@api userLanguage;
	@api customClass;
	labels = {
		labelAuthorBy,
		labelGroupName
	}
	@track sitePath
	@track publishedDate;
	@api isGuestUser;
	sitePrefix;
	attachmentPath;
	
	connectedCallback() {
		this.publishedDate = new Date(this.news.Publish_DateTime__c);
		this.get_SitePrefix();
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				this.sitePath   = result;
				this.sitePrefix = result.substring(0, result.lastIndexOf('/s'));
				this.attachmentPath = this.sitePrefix + constants.custom.ATTACHMENT_PATH;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	get hide_image() {
		return (!this.showImages);
	}
	
	get imageUrl() {
		let images = this.news.Attachments;
		let imageURL = this.news.imageURL;
		if (this.showImages) {
			if(imageURL != undefined) {
				return imageURL;
			}
			else if (images) {
				return this.attachmentPath + this.news.Attachments[0].Id;
			}
			return `${x7sNews_Custom}` + '/NewsCustom/images/default-news.png';
		}
		return '';
	}
	
	get newsLikeRowClass() {
		return classSet('x7s-news__like-row')
			.add({
				'slds-text-align_center': this.layout === 'vertical',
				'slds-text-align_right': this.layout === 'horizontal',
			})
			.toString();
	}
	
	get publishedBy() {
		return this.isNicknameDisplayEnabled ? this.news.Author__r.CommunityNickname : this.news.Author__r.Name;
	}
	
	get profileUrl() {
		return `${this.sitePath}${this.profileurl}${this.news.Author__c}`;
	}
	
	get useAvatar() {
		return (this.showImages && this.showAvatar);
	}
	
	get newsName() {
		let isGuestAndLanEnabel = this.isGuestUser ? false : this.languageEnabled ? true : false;
		let lanNotToUserLan = (this.news.Language__c != this.userLanguage ? true : false);
		if (isGuestAndLanEnabel) {
			if (lanNotToUserLan) {
				return this.news.X7S_News_Translation__r[0].Title__c;
			} else {
				return this.news.Name;
			}
		}
		return this.news.Name;
	}
	
	navigateToGroup() {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.news.GroupId__c,
				objectApiName: 'Group',
				actionName: 'view'
			}
		});
	}
}