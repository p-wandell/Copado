/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { constants} from "c/x7sNewsBase";

import getSitePrefix from '@salesforce/apex/x7sNewsController.getSitePrefix';
import get_NewsRecord from '@salesforce/apex/x7sNewsController.getNewsRecord';

import labelGroupName from "@salesforce/label/c.x7sNewsLabelGroupName";

export default class X7sNewsDetail extends NavigationMixin(LightningElement) {
	
	@api tileVariant = 'featured';
	@api layout = 'vertical';
	@api recordId;
	@api limitToSpecificGroups = false;
	@api customClass = '';
	@api ariaLandmarkRoleForComponent = 'region';

	sitePath;
	sitePrefix;
	ATTACHMENT_PATH = constants.custom.ATTACHMENT_PATH;
	attachmentPath;
	error;
	newsName;
	newsDetails;
	newsGroupId;
	newsPrivate;
	newArticleLanguage;
	translateNewsDetail;
	groupName;
	hideImage = true;
	groupLabel = labelGroupName;
	
	connectedCallback() {
		this.get_SitePrefix();
		this.getNewsRecord();
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				this.sitePath = result;
				let position = this.sitePath.lastIndexOf('/s');
				let sitePrefix = this.sitePath.substring(0, position);
				this.sitePrefix = sitePrefix;
				this.attachmentPath = sitePrefix + this.ATTACHMENT_PATH;
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	getNewsRecord() {
		get_NewsRecord({newsRecordId: this.recordId})
			.then(result => {
				let newsListWrapper = result;
				for (let i = 0; i < newsListWrapper.newsList.length; i++) {
					
					this.newsName = newsListWrapper.newsList[i]['Name'];
					this.newsDetails = newsListWrapper.newsList[i]['Details__c'];
					this.newsGroupId = newsListWrapper.newsList[i]['GroupId__c'] || '';
					this.newsPrivate = newsListWrapper.newsList[i]['Private_Group__c'];
					this.newArticleLanguage = newsListWrapper.newsList[i]['Language__c'];
					
					if (newsListWrapper.isGuestUser !== true) {
						if (newsListWrapper.languageEnable === true &&
							!!(newsListWrapper.newsList[i].X7S_News_Translation__r) &&
							newsListWrapper.newsList[i].X7S_News_Translation__r.length > 0) {
							this.translateNewsDetail = newsListWrapper.newsList[i].X7S_News_Translation__r[0]['Detail__c'];
						}
					}
					
					newsListWrapper.newsList[i].topics = [];
					if (newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]) {
						newsListWrapper.newsList[i].topics.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
					}
					this.newsListWrapper = newsListWrapper;
					if (this.limitToSpecificGroups) {
						this.groupName = newsListWrapper.groupIdToName[newsListWrapper.newsList[0]['GroupId__c']] || '';
					}
				}
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	navigateToGroup() {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.newsGroupId,
				objectApiName: 'Group',
				actionName: 'view'
			}
		});
	}
	
	get imageUrl() {
		if (this.newsListWrapper) {
			let attachments = this.newsListWrapper.newsList[0].Attachments
			if (attachments && attachments.length) {
				let attachId = this.newsListWrapper.newsList[0].Attachments[0].Id;
				if (attachId && attachId.length) {
					this.hideImage = false;
					return this.attachmentPath + attachId;
				}
				return '';
			}
		}
	}
	
	get description() {
		if (this.newsListWrapper) {
			let attachments = this.newsListWrapper.newsList[0].Attachments;
			if (attachments && attachments.length) {
				let attachId = this.newsListWrapper.newsList[0].Attachments[0].Id;
				if (attachId && attachId.length) {
					this.hideImage = false;
					return '';
				}
				return this.newsName;
			}
		}
	}
	
	get translatedNews() {
		if (this.newsListWrapper) {
			let lanEnable = this.newsListWrapper.isGuestUser ? false : !!this.newsListWrapper.languageEnable;
			let articleLang = this.newArticleLanguage !== this.newsListWrapper.userLanguage;
			if (lanEnable && articleLang) {
				return this.translateNewsDetail;
			}
			return this.newsDetails;
		}
		return this.newsDetails;
	}
}