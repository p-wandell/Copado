/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
import {LightningElement, api} from 'lwc';
import get_NewsRecord from '@salesforce/apex/x7sNewsController.getNewsRecord';
import is_NicknameDisplayEnabled from '@salesforce/apex/x7sNewsController.isNicknameDisplayEnabled';
import getSitePrefix from '@salesforce/apex/x7sNewsController.getSitePrefix';
import labelCommunityMemberSince from "@salesforce/label/c.x7sLabelCommunityMemberSince";

export default class X7sNewsPostedBy extends LightningElement {
	
	@api recordId;
	@api showNickName = false;
	@api showMemberSince = false;
	@api variant = "featured";
	@api showAvatar = false;
	@api customClass = '';
	@api headingTitle = 'Author';
	@api headerAlignment = 'center';
	@api profileURL = '/profile/';
	sitePath;
	isNicknameDisplayEnabled;
	newsListWrapper;
	error;
	communityNickname;
	authorName;
	profileId;
	communitySinceLabel = labelCommunityMemberSince;
	sinceDate;
	
	connectedCallback() {
		this.get_SitePrefix();
		this.get_is_NicknameDisplayEnabled();
		this.getNewsRecord();
	}
	
	getNewsRecord() {
		get_NewsRecord({newsRecordId: this.recordId})
			.then(result => {
				this.newsListWrapper = result;
				if (this.newsListWrapper !== null && this.newsListWrapper.netMem !== null && this.newsListWrapper.netMem.CreatedDate !== null) {
					this.sinceDate = this.newsListWrapper.netMem.CreatedDate;
				}
				this.author_Name();
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	get_is_NicknameDisplayEnabled() {
		is_NicknameDisplayEnabled()
			.then(result => {
				this.isNicknameDisplayEnabled = result;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				this.sitePath = result;
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	get showAuthor() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList)) {
			if (this.newsListWrapper.newsList.length) {
				return !!this.newsListWrapper.newsList[0].Show_Author__c;
			}
		}
		return false;
	}
	
	get sinceLabel() {
		return (this.showMemberSince) ? this.communitySinceLabel : '';
	}
	
	author_Name() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList)) {
			if (this.newsListWrapper.newsList.length) {
				if (this.newsListWrapper.newsList[0].Author__c) {
					if (this.isNicknameDisplayEnabled) {
						if (this.showNickName) {
							this.communityNickname = this.newsListWrapper.newsList[0].Author__r.CommunityNickname;
							this.profileId = this.newsListWrapper.newsList[0].Author__c;
						} else {
							this.communityNickname = this.newsListWrapper.newsList[0].Author__r.Name;
							this.profileId = this.newsListWrapper.newsList[0].Author__c;
						}
					} else {
						this.communityNickname = this.newsListWrapper.newsList[0].CreatedBy.Name;
						this.profileId = this.newsListWrapper.newsList[0].Author__c;
					}
				}
			}
		}
	}
	
	
	get imageUrl() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList)) {
			if (this.newsListWrapper.newsList.length) {
				return this.newsListWrapper.newsList[0].Author__c
					? this.newsListWrapper.newsList[0].Author__r.SmallPhotoUrl
					: this.newsListWrapper.newsList[0].CreatedBy.SmallPhotoUrl;
			}
		}
	}
	
	get showheadingTitle() {
		if (this.headingTitle) {
			return this.headingTitle;
		} else {
			return '';
		}
	}
}