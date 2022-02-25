/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
import {api, LightningElement, track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {formatText, inLexMode} from 'c/x7sShrUtils';
import {constants} from 'c/x7sNewsBase';

import x7sNewsEditNewsLabel from "@salesforce/label/c.x7sNewsEditNewsLabel";
import x7sNewsDeleteNewsLabel from "@salesforce/label/c.x7sNewsDeleteNewsLabel";
import get_News_Record from "@salesforce/apex/x7sNewsController.getNewsRecord";
import getSitePrefix from "@salesforce/apex/x7sNewsController.getSitePrefix";
import is_Object_Editable from "@salesforce/apex/x7sNewsController.isObjectEditable";
import is_Record_Editable from "@salesforce/apex/x7sNewsController.isRecordEditable";
import is_Record_Deletable from "@salesforce/apex/x7sNewsController.isRecordDeletable";
import delete_Record from "@salesforce/apex/x7sNewsController.deleteRecord";

import labelAuthorBy from "@salesforce/label/c.x7sNewsLabelAuthorBy";
import deleteConfirm from "@salesforce/label/c.x7sNewsConfirmDelete";

export default class X7sNewsDetailBanner extends NavigationMixin(LightningElement) {
	
	@api recordId;
	@api showTopics = "true";
	@api newsListURL = '7s-news-lwc';
	@api editNewsUrl = '7s-news-create';
	@api editNewsLabel = '';
	@api deleteNewsLabel = '';
	@api showLikeButton = "true";
	@api showFollowButton = "true";
	@api allowShowSource = false;
	@api limitToSpecificGroups = false;
	@api editsRequireTopics = false;
	@api customClass;
	@api variant = "featured";
	
	@track newsListWrapper;
	
	newArticalLanguage;
	translateRecordTitle;
	isObjectEditable;
	isRecordEditable;
	isRecordDeletable;
	profileurl = "/profile/";
	isEdit = false;
	sitePath;
	sitePrefix
	error;
	topics;
	publishedDate;
	labels = {
		labelAuthorBy
	}
	
	connectedCallback() {
		this.getNewsRecord();
		this.get_SitePrefix();
		this.getIsObjectEditable();
		this.getIsRecordEditable();
		this.getIsRecordDeletable();
	}
	
	getNewsRecord() {
		get_News_Record({newsRecordId: this.recordId})
			.then(result => {
				let newsListWrapper = result;
				if (newsListWrapper && !!(newsListWrapper.newsList)) {
					for (var i = 0; i < newsListWrapper.newsList.length; i++) {
						this.publishedDate = new Date(newsListWrapper.newsList[i]['Publish_DateTime__c']);
						newsListWrapper.newsList[i].topics = [];
						if (newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]) {
							newsListWrapper.newsList[i].topics.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
						}
						this.newArticalLanguage = newsListWrapper.newsList[i]['Language__c'];
						if (newsListWrapper.isGuestUser !== true) {
							if (newsListWrapper.languageEnable &&
								!!(newsListWrapper.newsList[i].X7S_News_Translation__r) &&
								newsListWrapper.newsList[i].X7S_News_Translation__r.length > 0) {
								this.translateRecordTitle = newsListWrapper.newsList[i].X7S_News_Translation__r[0]['Title__c'];
							}
						}
					}
					if (newsListWrapper.topicNameToId) {
						let data = newsListWrapper.topicNameToId;
						this.topics = Object.keys(data).map((key) => {
							return ({Name: key, Id: data[key], Topic: {Id: data[key], Name: key}});
						});
						console.log('-----topics----' + JSON.stringify(this.topics));
					}
				}
				this.newsListWrapper = newsListWrapper;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				let sitepath = result;
				this.sitePath = sitepath;
				this.sitePrefix = sitepath.replace("/s", "");
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	getIsObjectEditable() {
		is_Object_Editable()
			.then(result => {
				this.isObjectEditable = result;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	getIsRecordEditable() {
		is_Record_Editable({recordId: this.recordId})
			.then(result => {
				this.isRecordEditable = result;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	getIsRecordDeletable() {
		is_Record_Deletable({recordId: this.recordId})
			.then(result => {
				this.isRecordDeletable = result;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	deleteNewsRecord() {
		delete_Record({recordId: this.recordId})
			.then(result => {
				if (result === true) {
					this.goToNewsList();
				}
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	goToNewsList() {
		if (inLexMode()) {
            this[NavigationMixin.Navigate]({
                  type: 'standard__navItemPage',
                  attributes: {
                     apiName: this.newsListURL
                  }
               });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    pageName: this.newsListURL
                }
            });
        }
	}
	
	editNewsRecord() {
		let url = this.editNewsUrl;
		if (url) {
			const urlSet = constants.edit;
			
			if (inLexMode()) {
				this[NavigationMixin.Navigate]({
					type: 'standard__navItemPage',
					attributes: {
						apiName: url
					},
					state: {
						[urlSet.editMode]       : true,
						[urlSet.id]             : this.recordId,
						[urlSet.requireTopics]  : this.editsRequireTopics,
						[urlSet.limitGroups]    : this.limitToSpecificGroups,
						[urlSet.showSource]     : this.allowShowSource
					}
				});
			} else {
				this[NavigationMixin.Navigate]({
					type: 'comm__namedPage',
					attributes: {
						pageName: url
					},
					state: {
						[urlSet.editMode]       : true,
						[urlSet.id]             : this.recordId,
						[urlSet.requireTopics]  : this.editsRequireTopics,
						[urlSet.limitGroups]    : this.limitToSpecificGroups,
						[urlSet.showSource]     : this.allowShowSource
					}
				});
			}
		}
	}
	
	delete_News_Record() {
		let title = this.newsListWrapper.newsList[0].Name;
		if (confirm(formatText(deleteConfirm, title))) {
			this.deleteNewsRecord();
		}
	}
	
	get translatedNameOrTitle() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList) && this.newsListWrapper.newsList.length) {
			let languageEnable     = this.newsListWrapper.isGuestUser ? false : !!this.newsListWrapper.languageEnable;
			let newsArticleLanguage = this.newArticalLanguage !== this.newsListWrapper.userLanguage;
			if (languageEnable) {
				if (newsArticleLanguage) {
					return this.translateRecordTitle;
				} else {
					return this.newsListWrapper.newsList[0].Name;
				}
			}
			return this.newsListWrapper.newsList[0].Name;
		}
	}
	
	get publishedBy() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList) && this.newsListWrapper.newsList.length) {
			return this.newsListWrapper.newsList[0].Author__r.Name;
		}
		return this.newsListWrapper.newsList[0].Author__r.CommunityNickname;
	}
	
	get profileUrl() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList) && this.newsListWrapper.newsList.length) {
			return `${this.sitePath}${this.profileurl}${this.newsListWrapper.newsList[0].Author__c}`;
		}
	}
	
	get likeCount() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList) && this.newsListWrapper.newsList.length) {
			return this.newsListWrapper.newsList[0].Like_Count__c;
		}
		return "0";
	}
	
	get isShowAuthor() {
		if (this.newsListWrapper && !!(this.newsListWrapper.newsList) && this.newsListWrapper.newsList.length) {
			return this.newsListWrapper.newsList[0].Show_Author__c;
		}
	}
}