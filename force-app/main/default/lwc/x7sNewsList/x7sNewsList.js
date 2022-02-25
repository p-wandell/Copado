/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import {api, LightningElement, track, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

import getNews from "@salesforce/apex/x7sNewsController.getNews";
import nextPage from "@salesforce/apex/x7sNewsController.nextPage";
import previousPage from "@salesforce/apex/x7sNewsController.previousPage";
import getSitePrefix from "@salesforce/apex/x7sNewsController.getSitePrefix";
import is_Nickname_Display_Enabled from "@salesforce/apex/x7sNewsController.isNicknameDisplayEnabled";
import x7sNewsAriaLabelForNewsListLandmark from '@salesforce/label/c.x7sNewsAriaLabelForNewsListLandmark';


export default class X7sNewsList extends NavigationMixin(LightningElement) {
	
	@api recordId;
	@api tileVariant = 'default';
	@api layout = 'vertical';
	@api numberOfNewsPerPage = "12";
	@api showAvatar = false;
	@api showImages = "true";
	@api showTopic = "true";
	@api filterOn;
	@api filterId;
	@api profileURL = '/profile/';
	@api newsURL = '/news/';
	@api newsListURL = '/news-list';
	@api filterNewsListByTopic;
	@api showLikes = false;
	@api showComments = "true";
	@api limitToSpecificGroups = false;
	@api networkIds;
	@api customClass = '';
	@api listId = 'ID_1';
	@api newsListIds = '';
	@api ariaLandmarkRoleForComponent = 'region';
	
	@track currentURL;
	@track topicName;
	@track groupID;
	@track filterByAuthor;
	@track filterByTopic;
	@track strError;
	@track fromDate;
	@track toDate;
	@track searchString;
	@track sortBy;
	@track newsListWrapper;
	@track languageEnabled;
	@track userLanguage;
	@track totalNews;
	@track sitePath;
	@track sitePrefix;
	@track isNicknameDisplayEnabled;
	@track hasNextSet;
	@track hasPreviousSet;
	@track listofNewsIds = [];
	
	loading = true;
	TILE_MAX_TITLE_WIDTH = 40;
	
	layoutClass = 'slds-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_4-of-12';
	listViewClass = 'slds-size_12-of-12';
	ariaLabelForNewsListLandmark = x7sNewsAriaLabelForNewsListLandmark;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		let url = window.location.href;
		this.currentURL = encodeURIComponent(url);
		
		let urlParts = url.split(/[\/?]/);
		let filterOn = this.filterOn;
		
		if (filterOn === "Search Term") {
			// take the search term from the URL as {!searchTerm} does not seem to work
			let searchPos = urlParts.findIndex(item => item === 'global-search');
			this.searchString = searchPos !== -1 && urlParts.length > searchPos ? urlParts[searchPos + 1] : this.filterId;
		} else if (filterOn === "Topic Value") {
			// Topic uses the topic name
			let searchPos = urlParts.findIndex(item => item === 'topic');
			this.topicName = searchPos !== -1 && urlParts.length > searchPos ? urlParts[searchPos + 1] : this.filterId;
		} else if (filterOn === "Group") {
			// Group uses the ID
			let searchPos = urlParts.findIndex(item => item === 'group');
			this.groupID = searchPos !== -1 && urlParts.length > searchPos ? urlParts[searchPos + 1] : this.filterId;
		} else if (filterOn === 'Author') {
			this.filterByAuthor = this.recordId || this.filterId;
		} else {
			this.filterId = this.recordId;
		}
		
		// check to see if the user set a default topic filter
		let filterNewsListByTopic = this.filterNewsListByTopic;
		if (filterNewsListByTopic !== undefined && filterNewsListByTopic !== '') {
			this.filterByTopic = filterNewsListByTopic;
		}
		
		if (this.newsListIds && this.newsListIds.length > 0) {
			let listofNewsIds = [];
			listofNewsIds = this.newsListIds.split(",");
			listofNewsIds.forEach(function (Id, index) {
				this.listofNewsIds.push(Id.trim());
			}.bind(this));
		}
		this.get_SitePrefix();
		this.get_isNicknameDisplayEnabled();
		this.getNewsList();
		registerListener("newsstartdate", this.handleStartDate, this);
		registerListener("newsenddate", this.handleEndDate, this);
		registerListener("searchstring", this.handleSearchString, this);
		registerListener("sortbyevent", this.sortbyhandle, this);
		registerListener("cardviewoption", this.cardHandle, this);
		registerListener("listviewoption", this.listHandle, this);
		registerListener("newstopicevent", this.handleTopic, this);
		registerListener("newsauthorevent", this.handleAuthor, this);
		registerListener("pageprevious", this.previousHandle, this);
		registerListener("pagenext", this.nextHandle, this);
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'totalnews', {id: this.listId, value: this.totalNews});
		fireEvent(this.pageRef, 'listhasnext', {id: this.listId, value: this.hasNextSet});
		fireEvent(this.pageRef, 'listhasprevious', {id: this.listId, value: this.hasPreviousSet});
		fireEvent(this.pageRef, 'listpagenumber', {id: this.listId, value: this.pageNumber});
		fireEvent(this.pageRef, 'listtotalpages', {id: this.listId, value: this.totalPages});
		fireEvent(this.pageRef, 'listdefaultview', {id: this.listId, value: this.layout});
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get componentClass() {
		return `x7s-groups-list ${this.customClass}`;
	}
	
	get viewSelectorStyle() {
		return (this.layout !== 'horizontal') ? `${this.layoutClass}` : `${this.listViewClass}`;
	}
	
	get cardTextAlign() {
		return this.layout === 'vertical' ? 'center' : 'left';
	}
	
	getNewsList() {
		this.loading = true;
		let groupId = this.groupID;
		if (groupId) {
			this.topicName = groupId !== '' ? groupId : this.topicName;
		}
		
		getNews(this.getParams())
			.then(result => {
				this.processData(result);
				this.loading = false;
				if (this.newsListWrapper.field !== '' && this.newsListWrapper.field !== null) {
					if (this.newsListWrapper.field === 'Date') {
						
						if (this.newsListWrapper.errorMsg !== '' && this.newsListWrapper.errorMsg !== null) {
							if (this.newsListWrapper.errorMsg === 'List index out of bounds: 1') {
								this.strError = 'Invalid Date.';
							} else {
								this.strError = 'Unexpected Error Occurred, Please contact your Administrator.';
							}
						}
					} else {
						if (this.newsListWrapper.errorMsg !== '' && this.newsListWrapper.errorMsg !== null)
							this.strError = 'Unexpected Error Occured, Please contact your Administrator.';
					}
				}
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	//pagination handlers
	previousHandle(evt) {
		if (this.listId === evt.id) {
			let params = this.getParams();
			params.pageNumber = this.pageNumber;
			
			previousPage(params)
				.then(result => {
					this.pageNumber -= 1;
					this.processData(result);
				})
				.catch(error => {
					this.error = error;
				});
		}
	}
	
	nextHandle(evt) {
		if (this.listId === evt.id) {
			let params = this.getParams();
			params.pageNumber = this.pageNumber;
			
			nextPage(params)
				.then(result => {
					this.pageNumber += 1;
					this.processData(result);
				})
				.catch(error => {
					this.error = error;
				});
		}
	}
	
	// Evens
	handleTopic(evt) {
		if (this.listId === evt.id) {
			this.filterByTopic = evt.value;
			this.getNewsList();
		}
	}
	
	handleAuthor(evt) {
		if (this.listId === evt.id) {
			this.filterByAuthor = evt.value;
			this.getNewsList();
		}
	}
	
	handleSearchString(evt) {
		if (this.listId === evt.id) {
			this.searchString = evt.value;
			this.getNewsList();
		}
	}
	
	handleStartDate(evt) {
		if (this.listId === evt.id) {
			this.startDate = evt.value;
			this.getNewsList();
		}
	}
	
	handleEndDate(evt) {
		if (this.listId === evt.id) {
			this.endDate = evt.value;
			this.getNewsList();
		}
	}
	
	sortbyhandle(evt) {
		if (this.listId === evt.id) {
			this.sortBy = evt.value;
			this.getNewsList();
		}
	}
	
	cardHandle(evt) {
		if (this.listId === evt.id) {
			this.layout = 'vertical'; // vertical, horizontal
		}
	}
	
	listHandle(evt) {
		if (this.listId === evt.id) {
			this.layout = 'horizontal'; // vertical, horizontal
		}
	}
	
	getParams() {
		let regex = /;/gi;
		
		let filterByTopic = this.filterByTopic;
		if (filterByTopic) {
			filterByTopic = filterByTopic.replace(regex, ',');
		}
		
		let filterByAuthor = this.filterByAuthor;
		if (filterByAuthor) {
			filterByAuthor = filterByAuthor.replace(regex, ',');
		}
		let params = {
			numberOfNewsPerPage: this.numberOfNewsPerPage,
			strRecordId: this.filterId,
			networkIds: this.networkIds,
			sortBy: this.sortBy,
			filterByTopic: filterByTopic,
			filterByAuthor: filterByAuthor,
			topicName: this.topicName,
			filterOn: this.filterOn,
			searchTerm: this.searchString,
			fromDate: this.startDate,
			toDate: this.endDate,
			listofNewsIds: this.listofNewsIds
		};
		return params;
	}
	
	updateNewsWrapper(newsListWrapper) {
		for (let i = 0; i < newsListWrapper.newsList.length; i++) {
			let newsItem = newsListWrapper.newsList[i];
			
			newsListWrapper.newsList[i].commentCount = newsListWrapper.newsToCommentCountMap[newsListWrapper.newsList[i].Id];
			if (newsListWrapper.likedNewsIds) {
				newsListWrapper.newsList[i].isLiking = newsListWrapper.likedNewsIds.includes(newsListWrapper.newsList[i].Id);
			}
			
			// check if the title can be SLDS clamped or SLDS truncated - if no spaces, truncate else clamp
			newsListWrapper.newsList[i].clamp = true;
			if (newsItem.Name.length > this.TILE_MAX_TITLE_WIDTH) {
				let spaceIndex = newsItem.Name.indexOf(' ');
				if (spaceIndex === -1 || spaceIndex > this.TILE_MAX_TITLE_WIDTH) {
					newsListWrapper.newsList[i].clamp = false;
					newsListWrapper.newsList[i].Name = newsListWrapper.newsList[i].Name.substring(0, 70);
				}
			}
			
			newsListWrapper.newsList[i].topics1 = [];
			newsListWrapper.newsList[i].topics1.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
			newsListWrapper.newsList[i].topics = [];
			newsListWrapper.newsList[i].groupName = newsListWrapper.groupIdToName[newsListWrapper.newsList[i]['GroupId__c']];
			
			/* Logic for topics will be displayed till 27 characters only */
			if (newsListWrapper.newsList[i].topics1 !== undefined && this.showTopic) {
				for (let j = 0; j < newsListWrapper.newsList[i].topics1.length; j++) {
					if (newsListWrapper.newsList[i].topics1[j] !== undefined) {
						for (let jj = 0; jj < newsListWrapper.newsList[i].topics1[j].length; jj++) {
							if (newsListWrapper.newsList[i].topics !== undefined) {
								newsListWrapper.newsList[i].topics.push(newsListWrapper.newsList[i].topics1[j][jj]);
							}
						}
					}
				}
			}
			newsListWrapper.newsList[i].imageURL = newsListWrapper.newsIdtoimageURLMap[newsItem.Id];
		}
		return newsListWrapper;
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				let sitePath = result;
				this.sitePath = result;
				if (sitePath[sitePath.length - 1] === 's') {
					this.sitePrefix = sitePath.substring(0, sitePath.length - 2);
				} else {
					this.sitePrefix = sitePath.replace("/s", "/");
				}
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	get_isNicknameDisplayEnabled() {
		is_Nickname_Display_Enabled()
			.then(result => {
				this.isNicknameDisplayEnabled = result;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	processData(data) {
		this.newsListWrapper = this.updateNewsWrapper(data);
		this.pageNumber = this.newsListWrapper.pageNumber;
		this.totalPages = this.newsListWrapper.totalPages;
		this.hasPreviousSet = this.newsListWrapper.hasPreviousSet;
		this.hasNextSet = this.newsListWrapper.hasNextSet;
		this.totalResults = this.newsListWrapper.totalResults;
		this.languageEnabled = this.newsListWrapper.languageEnable;
		this.userLanguage = this.newsListWrapper.userLanguage;
		this.totalNews = this.newsListWrapper.totalResults;
	}
}