/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import currentUserId from '@salesforce/user/Id';

import {updateIdeaValues} from 'c/x7sIdeasBase';
import {fireEvent, registerListener, unregisterAllListeners,inLexMode} from 'c/x7sShrUtils';

import getVotingDetails from "@salesforce/apex/x7sIdeasListController.getVotingDetails";
import get_Zone_Id from "@salesforce/apex/x7sIdeasListController.getZoneId";
import get_Common_Settings from "@salesforce/apex/x7sIdeasListController.getCommonSettings";
import get_Ideas from "@salesforce/apex/x7sIdeasListController.getIdeas";
import nextPage from "@salesforce/apex/x7sIdeasListController.nextPage";
import previousPage from "@salesforce/apex/x7sIdeasListController.previousPage";
import labelAriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";

export default class X7sIdeasList extends NavigationMixin(LightningElement) {
	
	@api listId = 'ID_1';
	@api zoneName = 'Internal Zone';
	@api customClass = '';
	@api tileVariant = 'None';
	@api layout = 'Card';
	@api listSize = "12";
	@api showAvatar = false;
	@api showImages = "true";
	@api displayPostDateAuthor = "true";
	@api displayMergeIdeas = "true";
	@api sortBy;
	@api searchString;
	@api searchByTopics;
	@api searchByTheme;
	@api searchByStatus;
	@api searchByCategories;
	@api searchMyIdeas;
	@api ideasListURL = 'X7S_Idea_List__c';
	@api ideaDetailURL = 'X7S_Idea_Detail__c';
	@api accountLimitReachedMessage = '0';
	@api showDescription = "true";
	@api descriptionLineCount = 2;
	@api showStatus = "true";
    @api showTopic = "true";
	@api showEdit = false;
	@api showDelete =false;
	@api showVote = false;
	@api showRemoveVote = false;
	@api ideaNewURL = 'X7S_Idea Create_Edit__c';
	
	isNicknameDisplayEnabled = true;
	enableDownVoting = false;
	voteDisableStatus = '';
	showAlternateCTA = false;
	userId = currentUserId;
	sitePath = '';
	sitePrefix = '';
	zoneError;
	zoneId;
	totalIdeas;
	hasNextSet;
	hasPreviousSet;
	pageNumber;
	totalPages;
	totalResults;
	searchMyVotedIdeas;
	searchMyCommentedIdeas;
	searchMySubscribedIdeas;
	searchMyCompanyIdeas;
	searchMyCompanyVotedIdeas;
	searchMyCompanyCommentedIdeas;
	searchMyCompanySubscribedIdeas;
	baseLoaded = false;
	filterOn = 'None';
	layoutClass = 'slds-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_4-of-12';
	listViewClass = 'slds-size_12-of-12';
	ideaListWrapper;
	baseModel;
	showSpinner = true;
	filterTopicValue = '';
	filterCatValue = '';
	filterStatusValue = '';
	filterThemeValue = '';
	
	labels = {
		labelAriaWrapper
	}
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		
		let baseLoaded = this.baseLoaded;
		
		if (!baseLoaded) {
			this.baseLoaded = true;
			
			// Capture the initial filter settings
			this.filterTopicValue = this.searchByTopics;
			this.filterCatValue = this.searchByCategories;
			this.filterStatusValue = this.searchByStatus;
			this.filterThemeValue = this.searchByTheme;
			
			this.getCommonSettings();
			
			let url = window.location.href;
			this.currentURL = encodeURIComponent(url);
			let urlParts = url.split(/[\/?]/);
			
			let topicValue = '';
			let searchPos = urlParts.findIndex(item => item === 'topic');
			if (searchPos !== -1) {
				topicValue = decodeURIComponent(urlParts.length > searchPos + 1
					? urlParts[searchPos + 2]
					: this.searchByTopics);
			}
			
			let searchTerm = this.searchString;
			if (searchTerm) {
				this.searchTermValue = searchTerm;
			}
			
			if (this.filterOn === 'Search Term') {
				this.searchTermValue = topicValue;
			}
			
			if (this.searchMyIdeas === 'Topic') {
				this.topicValue = topicValue;
			}
			this.showSpinner = true;
			
			this.getZoneId();
			//this.getIdeasList();
			this.getAccountVotingLimits();
		}
		registerListener("searchstring", this.handleSearchString, this);
		registerListener("sortbyevent", this.sortbyhandle, this);
		registerListener("ideasfiltertheme", this.handleFilterTheme, this);
		registerListener("ideasfiltertopic", this.handleFilterTopic, this);
		registerListener("ideasfilterstatus", this.handleFilterStatus, this);
		registerListener("ideasfiltercategory", this.handleFilterCategory, this);
		registerListener("ideasfilterevent", this.setIdeasFilters, this);
		registerListener("cardviewoption", this.cardHandle, this);
		registerListener("listviewoption", this.listHandle, this);
		registerListener("pageprevious", this.previousHandle, this);
		registerListener("pagenext", this.nextHandle, this);
        registerListener("tableviewoption", this.tableHandle, this);
	}
	
	disconnectedCallback() {
		// unsubscribe from all event
		unregisterAllListeners(this);
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'totalideas', {id: this.listId, value: this.totalResults});
		fireEvent(this.pageRef, 'listhasnext', {id: this.listId, value: this.hasNextSet});
		fireEvent(this.pageRef, 'listhasprevious', {id: this.listId, value: this.hasPreviousSet});
		fireEvent(this.pageRef, 'listpagenumber', {id: this.listId, value: this.pageNumber});
		fireEvent(this.pageRef, 'listtotalpages', {id: this.listId, value: this.totalPages});
		fireEvent(this.pageRef, 'listdefaultview', {id: this.listId, value: this.layout});
	}
	
	getIdeasList() {
		this.showSpinner = true;
		get_Ideas(this.updateListParams(false))
			.then(result => {
				this.processData(result);
				fireEvent(this.pageRef, 'totalideas', {id: this.listId, value: this.totalResults});
				this.showSpinner = false;
			})
			.catch(error => {
				this.showSpinner = false;
				this.errorMessage(error, false, 'getIdeasList');
			});
	}
	
	get showTitleText() {
		return (this.showTitle && this.titleText);
	}
	
	get componentClass() {
		return `x7s-groups-list ${this.customClass}`;
	}
	
	get viewSelectorStyle() {
		return (this.layout !== 'List' && this.layout !== 'Table') ? `${this.layoutClass}` : `${this.listViewClass}`;
	}
	
	get cardTextAlign() {
		return this.layout === 'Card' ? 'center' : 'left';
	}
	get autoSlds(){
		return inLexMode();
	}
	get isTableView() {
		return (this.layout === 'Table') ? true :  false;
	}
	
	handleFilterTheme(evt) {
		if (this.listId === evt.id) {
			let newThemeSearch = evt.searchByTheme.trim();
			if (newThemeSearch.length === 0) {
				newThemeSearch = this.filterThemeValue;
			}
			this.searchByTheme = newThemeSearch;
			this.getIdeasList();
		}
	}
	
	handleFilterTopic(evt) {
		if (this.listId === evt.id) {
			let newTopicSearch = evt.searchByTopics.trim();
			if (newTopicSearch.length === 0) {
				newTopicSearch = this.filterTopicValue;
			}
			this.searchByTopics = newTopicSearch;
			this.getIdeasList();
		}
	}
	
	handleFilterStatus(evt) {
		if (this.listId === evt.id) {
			let newStatusSearch = evt.searchByStatus.trim();
			let filterStatusValue = this.filterStatusValue;
			
			if (newStatusSearch.length === 0) {
				newStatusSearch = filterStatusValue;
			} else {
				if (filterStatusValue && filterStatusValue.length > 0) {
					let filterEntries = filterStatusValue.split(',');
					if (!filterEntries.includes(newStatusSearch)) {
						newStatusSearch = filterStatusValue;
					}
				}
			}
			this.searchByStatus = newStatusSearch;
			this.getIdeasList();
		}
	}
	
	handleFilterCategory(evt) {
		if (this.listId === evt.id) {
			let newCategorySearch = evt.searchByCategory.trim();
			if (newCategorySearch.length === 0) {
				newCategorySearch = this.filterCatValue;
			}
			this.searchByCategories = newCategorySearch;
			this.getIdeasList();
		}
	}
	
	sortbyhandle(evt) {
		if (this.listId === evt.id) {
			let sortBy = evt.value;
			this.sortBy = sortBy.trim();
			this.getIdeasList();
		}
	}
	
	handleSearchString(evt) {
		if (this.listId === evt.id) {
			this.searchString = evt.value;
			this.searchString = this.searchString.replace('%', '\%').trim();
			this.getIdeasList();
		}
	}
	
	cardHandle(evt) {
		if (this.listId === evt.id) {
			this.layout = 'Card'; 
		}
	}
	
	listHandle(evt) {
		if (this.listId === evt.id) {
			this.layout = 'List'; 
		}
	}
	tableHandle(event) {
		if (this.listId === event.id) {
		    this.layout = 'Table'; 
		}
  	}
	updateListParams(paginate) {
		
		const searchByTopic = (this.topicValue) && this.topicValue.trim().length > 0
			? this.topicValue
			: this.searchByTopics;
		
		const filterByTopic = this.topicValue && this.topicValue.trim().length > 0;
		
		let params = {
			listSize: this.listSize,
			categories: this.categories,
			zoneId: this.zoneId,
			filterByTopic: filterByTopic,
			topicName: this.topicValue,
			filterBySearchTerm: this.filterOn === 'Search Term',
			searchTerm: this.searchString,
			searchMyIdeas: this.searchMyIdeas === 'Display My Voted Ideas Only' ? '' : this.searchMyIdeas,
			searchByCategories: this.searchByCategories,
			searchByTopics: this.searchByTopics,
			searchByStatus: this.searchByStatus,
			searchByThemes: this.searchByTheme,
			filterOnUserOwned: this.searchMyIdeas === 'Display My Ideas Only',
			filterOnUserVoted: this.searchMyIdeas === 'Display My Voted Ideas Only',
			sortBy: this.sortBy,
			filterByMergeIdea: this.displayMergeIdeas,
			limitVoteToEmailDomain: this.limitVoteToEmailDomain,
			filterByMyVotedIdeas: this.searchMyVotedIdeas === 'Display My Voted Ideas',
			searchByMyVotedIdeas: this.searchMyVotedIdeas,
			filterMyCommentedIdeas: this.searchMyCommentedIdeas === 'Display My Commented Ideas Only',
			searchMyCommentedIdeas: this.searchMyCommentedIdeas,
			filterMySubscribedIdeas: this.searchMySubscribedIdeas === 'Display My Subscribed Ideas Only',
			searchMySubscribedIdeas: this.searchMySubscribedIdeas,
			filterMyCompanyIdeas: this.searchMyCompanyIdeas === 'Display My Company Ideas Only',
			searchMyCompanyIdeas: this.searchMyCompanyIdeas,
			filterMyCompanyVotedIdeas: this.searchMyCompanyVotedIdeas === 'Display My Company Voted Ideas Only',
			searchMyCompanyVotedIdeas: this.searchMyCompanyVotedIdeas,
			filterMyCompanyCommentedIdeas: this.searchMyCompanyCommentedIdeas === 'Display My Company Commented Ideas Only',
			searchMyCompanyCommentedIdeas: this.searchMyCompanyCommentedIdeas,
			filterMyCompanySubscribedIdeas: this.searchMyCompanySubscribedIdeas === 'Display My Company Subscribed Ideas Only',
			searchMyCompanySubscribedIdeas: this.searchMyCompanySubscribedIdeas
		};
		
		if (paginate) {
			params['pageNumber'] = this.ideaListWrapper.pageNumber;
		}
		
		return params;
	}
	
	previousHandle(evt) {
		this.showSpinner = true;
		if (this.listId === evt.id) {
			previousPage(this.updateListParams(true))
				.then(result => {
					this.processData(result);
					this.showSpinner = false;
				})
				.catch(error => {
					this.showSpinner = false;
					this.errorMessage(error, false, 'getPreviousPage');
				});
		}
	}
	
	nextHandle(evt) {
		this.showSpinner = true;
		if (this.listId === evt.id) {
			nextPage(this.updateListParams(true))
				.then(result => {
					this.processData(result);
					this.showSpinner = false;
				})
				.catch(error => {
					this.showSpinner = false;
					this.errorMessage(error, false, 'getNextPage');
				});
		}
	}
	
	getAccountVotingLimits() {
		getVotingDetails({ideaId: ''})
			.then(result => {
				this.accountLimitReachedMessage = result.accountVoteLimitMessage;
			})
			.catch(error => {
				this.errorMessage(error, false, '');
			});
	}
	
	getZoneId() {
		get_Zone_Id({nameValue: this.zoneName})
			.then(value => {
				if (value !== '') {
					this.zoneId = value;
					this.getIdeasList();
				} else {
					this.zoneError = "Zone not set in builder";
				}
			})
			.catch(error => {
				this.errorMessage(error, false, 'Get Zone Id');
			});
	}
	
	getCommonSettings() {
		get_Common_Settings({zoneName: this.zoneName})
			.then(settings => {
				this.zoneId = settings.zoneId;
				this.sitePath = settings.sitePath;
				this.sitePrefix = this.sitePath.substring(0, this.sitePath.lastIndexOf('/s'));
				this.enableDownVoting = settings.allowDownVoting;
				this.voteDisableStatus = settings.voteDisableStatus;
				this.showAlternateCTA = settings.showAlternateCTA;
				this.isNicknameDisplayEnabled = settings.isNicknameDisplayEnabled;
			})
			.catch(error => {
				this.errorMessage(error, false, 'Get Common Settings');
			});
	}
	
	enableVote(settings) {
		return settings.disableReadOnlyUsers ? settings.isAuthenticated && settings.canCreateNew : true;
	}
	
	errorMessage(errors, hideToast, toastTitle) {
		if (errors && errors[0] && errors[0].message && !hideToast) {
			this.showMessage("error", toastTitle || 'Callback failed', errors[0].message);
		} else if (!hideToast) {
			this.showMessage("error", 'Callback failed', toastTitle);
		}
	}
	
	showMessage(variant, title, message) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
	
	updateListWrapper(result) {
		let ideaListWrapper = result;
		let topicMap = ideaListWrapper.topicNameToId;
		
		let sortBy = this.sortBy;
		let sitePath = this.sitePath;
		
		for (let i = 0; i < ideaListWrapper.ideaList.length; i++) {
			ideaListWrapper.ideaList[i] = updateIdeaValues(
				ideaListWrapper.ideaList[i],
				topicMap,
				sitePath,
				sortBy,
				this.voteDisableStatus,
				this.pageRef);
		}
		return ideaListWrapper;
	}
	
	setIdeasFilters(event) {
		// ignore other ideas lists
		if (event.id === this.listId) {
			let searchMyIdeas = event.searchMyIdeas;
			let searchMyVotedIdeas = event.searchMyVotedIdeas;
			let searchMyCommentedIdeas = event.searchMyCommentedIdeas;
			let searchMySubscribedIdeas = event.searchMySubscribedIdeas;
			let searchMyCompanyIdeas = event.searchMyCompanyIdeas;
			let searchMyCompanyVotedIdeas = event.searchMyCompanyVotedIdeas;
			let searchMyCompanyCommentedIdeas = event.searchMyCompanyCommentedIdeas;
			let searchMyCompanySubscribedIdeas = event.searchMyCompanySubscribedIdeas;
			
			//send a ' ' character to clear the filter
			if (searchMyIdeas && searchMyIdeas !== 'empty') {
				this.searchMyIdeas = searchMyIdeas.trim();
			} else if (searchMyIdeas === 'empty') {
				this.searchMyIdeas = '';
			}
			
			if (searchMyVotedIdeas && searchMyVotedIdeas !== 'empty') {
				this.searchMyVotedIdeas = searchMyVotedIdeas.trim();
			} else if (searchMyVotedIdeas === 'empty') {
				this.searchMyVotedIdeas = '';
			}
			
			if (searchMyCommentedIdeas && searchMyCommentedIdeas !== 'empty') {
				this.searchMyCommentedIdeas = searchMyCommentedIdeas.trim();
			} else if (searchMyCommentedIdeas === 'empty') {
				this.searchMyCommentedIdeas = '';
			}
			
			if (searchMySubscribedIdeas && searchMySubscribedIdeas !== 'empty') {
				this.searchMySubscribedIdeas = searchMySubscribedIdeas.trim();
			} else if (searchMySubscribedIdeas === 'empty') {
				this.searchMySubscribedIdeas = '';
			}
			
			if (searchMyCompanyIdeas && searchMyCompanyIdeas !== 'empty') {
				this.searchMyCompanyIdeas = searchMyCompanyIdeas.trim();
			} else if (searchMyCompanyIdeas === 'empty') {
				this.searchMyCompanyIdeas = '';
			}
			
			if (searchMyCompanyVotedIdeas && searchMyCompanyVotedIdeas !== 'empty') {
				this.searchMyCompanyVotedIdeas = searchMyCompanyVotedIdeas.trim();
			} else if (searchMyCompanyVotedIdeas === 'empty') {
				this.searchMyCompanyVotedIdeas = '';
			}
			
			if (searchMyCompanyCommentedIdeas && searchMyCompanyCommentedIdeas !== 'empty') {
				this.searchMyCompanyCommentedIdeas = searchMyCompanyCommentedIdeas.trim();
			} else if (searchMyCompanyCommentedIdeas === 'empty') {
				this.searchMyCompanyCommentedIdeas = '';
			}
			
			if (searchMyCompanySubscribedIdeas && searchMyCompanySubscribedIdeas !== 'empty') {
				this.searchMyCompanySubscribedIdeas = searchMyCompanySubscribedIdeas.trim();
			} else if (searchMyCompanySubscribedIdeas === 'empty') {
				this.searchMyCompanySubscribedIdeas = '';
			}
			this.getIdeasList();
		}
	}
	
	processData(data) {
		this.ideaListWrapper = this.updateListWrapper(data);
		this.pageNumber = this.ideaListWrapper.pageNumber;
		this.totalPages = this.ideaListWrapper.totalPages;
		this.hasPreviousSet = this.ideaListWrapper.hasPreviousSet;
		this.hasNextSet = this.ideaListWrapper.hasNextSet;
		this.totalResults = this.ideaListWrapper.totalResults;
		fireEvent(this.pageRef, 'TableViewData', {id: this.listId, value: this.ideaListWrapper});
	}
}